locals {
  frontend_port_name             = "${var.name}-feport"
  frontend_ip_configuration_name = "${var.name}-feip"
  gateway_ip_configuration_name  = "${var.name}-gipc"
  diag_appgw_logs = [
    "ApplicationGatewayAccessLog",
    "ApplicationGatewayPerformanceLog",
    "ApplicationGatewayFirewallLog",
  ]
  diag_appgw_metrics = [
    "AllMetrics",
  ]
  security_headers = [
    {
      name  = "Strict-Transport-Security"
      content = "max-age=31536000"
    },
    {
      "name": "Content-Security-Policy",
      "content": "default-src 'self' *.microsoftonline.com *.core.windows.net *.azureedge.net; script-src 'self' *.microsoftonline.com *.core.windows.net *.azureedge.net 'unsafe-eval' 'unsafe-inline'; style-src 'self' *.microsoftonline.com *.core.windows.net *.azureedge.net 'unsafe-inline'; img-src 'self' ecco-exportmodule-urihandler-p.azurewebsites.net ile-cp.s3.eu-central-1.amazonaws.com p3.aprimocdn.net *.microsoftonline.com *.core.windows.net *.azureedge.net data:; connect-src 'self' *.microsoftonline.com *.core.windows.net *.azureedge.net; font-src 'self' *.microsoftonline.com *.core.windows.net *.azureedge.net data:"
    }

  ]

}

resource "azurerm_public_ip" "pip" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_user_assigned_identity" "base" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.user_identity_name
}



resource "azurerm_key_vault_access_policy" "kvap" {
  key_vault_id = var.vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.base.principal_id

  key_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}


resource "azurerm_web_application_firewall_policy" "agw_policy" {
  name                = "afwp-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    enabled                         = var.policy_enabled
    mode                        = "Detection"
    max_request_body_size_in_kb = 2000
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
      # possible finer grained tuning if when we have more insights
      #rule_group_override {
      #  rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-921-PROTOCOL-ATTACK"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-932-APPLICATION-ATTACK-RCE"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-933-APPLICATION-ATTACK-PHP"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION"
      #}
      #rule_group_override {
      #  rule_group_name = "REQUEST-944-APPLICATION-ATTACK-JAVA"
      #}
    }
  }

}


resource "azurerm_application_gateway" "agw" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  enable_http2        = var.enable_http2
  firewall_policy_id  = azurerm_web_application_firewall_policy.agw_policy.id

   sku {
    name = var.sku.name
    tier = var.sku.tier
  }

  identity {
      type         = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.base.id]
  }

    autoscale_configuration {
    min_capacity = var.autoscale_configuration.min_capacity
    max_capacity = var.autoscale_configuration.max_capacity
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_targets
    content {
      name  = backend_address_pool.value.name
      fqdns = backend_address_pool.value.fqdns
    }
  }

  ssl_policy {
    policy_type          = "Custom"
    min_protocol_version = "TLSv1_2"

    cipher_suites = [
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
    ]
    

  }

  dynamic "backend_http_settings" {
    for_each = var.backend_targets
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = "Disabled"
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = backend_http_settings.value.name
      pick_host_name_from_backend_address = true
      
    }
  }


  http_listener{
    name                             = var.backend_targets[0].name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      host_name                      = var.backend_targets[0].a_record_name
      protocol                       = var.backend_targets[0].protocol
      ssl_certificate_name           = var.backend_targets[0].name

  }

  ssl_certificate{
    name                = var.backend_targets[0].name
    key_vault_secret_id = data.azurerm_key_vault_certificate.certificate[var.backend_targets[0].name].secret_id
  }



  request_routing_rule {
    name = "web"
    rule_type                  = "PathBasedRouting"
    http_listener_name         = var.backend_targets[0].name
    priority = "10"
    
    url_path_map_name = "ds-main"
  }

  url_path_map {
    name                               = "ds-main"
    default_backend_address_pool_name  = "web"
    default_backend_http_settings_name = "web"

    dynamic "path_rule" {
    for_each = var.backend_targets
      content {
        name                           = path_rule.value.path_name
        paths                          = path_rule.value.path
        backend_address_pool_name      = path_rule.value.name
        backend_http_settings_name     = path_rule.value.name
        rewrite_rule_set_name          = "ReWriteRulesSet"
      }
    }


  }


  rewrite_rule_set {
    name = "ReWriteRulesSet"

    rewrite_rule {
      name          = "content_header_rule"
      rule_sequence = 1



      dynamic "response_header_configuration" {
        for_each = local.security_headers
          content {
            header_name  = response_header_configuration.value.name
            header_value = response_header_configuration.value.content
          }
      }
    }

    dynamic "rewrite_rule" {
    for_each = var.rewrite_rules
      content {

      name          = "${rewrite_rule.value.name} rule"
      rule_sequence = index(var.rewrite_rules, rewrite_rule.value) + 1


        condition{
          ignore_case = true
          negate      = false
          pattern     = "(.*)/${rewrite_rule.value.rewrite_pattern}/(.*)"
          variable    = "var_uri_path"
        }

        url{
          path         = "{var_uri_path_1}/{var_uri_path_2}"
          components   = "path_only"
          reroute      = false
          }

        dynamic "response_header_configuration" {
          for_each = local.security_headers
          content {
            header_name  = response_header_configuration.value.name
            header_value = response_header_configuration.value.content
          }
        }
      }
    }

  }

  dynamic "probe" {
    for_each = var.backend_targets
    content {
      host                = one(probe.value.fqdns)
      interval            = 30
      name                = probe.value.name
      protocol            = probe.value.protocol
      path                = probe.value.health_path
      timeout             = 30
      unhealthy_threshold = 3
      port                = probe.value.port
    }
  }

  tags = {
    "costcenter" = "108000060"
  }
}



resource "azurerm_monitor_diagnostic_setting" "agw" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_application_gateway.agw.id
  log_analytics_workspace_id = var.la_workspace_long_id
  dynamic "log" {
    for_each = local.diag_appgw_logs
    content {
      category = log.value

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = local.diag_appgw_metrics
    content {
      category = metric.value

      retention_policy {
        enabled = false
      }
    }
  }
}

#resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
#  name                = "agw-diagnostic-logs"
#  target_resource_id          = azurerm_application_gateway.agw.id
#  log_analytics_workspace_id  = var.la_workspace_id
#
#  log {
#    category = "ApplicationGatewayAccessLog"
#    enabled  = false
#
#    retention_policy {
#      enabled = false
#    }
#  }
#
#  metric {
#    category = "AllMetrics"
#
#    retention_policy {
#      enabled = false
#    }
#  }
#}
