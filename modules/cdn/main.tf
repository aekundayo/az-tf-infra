
resource "random_string" "azurerm_cdn_name" {
  length  = 10
  lower   = true
  numeric = false
  special = false
  upper   = false
}


resource "azurerm_cdn_profile" "static-web-cdnprofile" {
  name                      = "ds-cdn-${var.env}-profile-${random_string.azurerm_cdn_name.result}"
  resource_group_name       = var.resource_group_name
  location                  = "Global"
  sku                       = "Standard_Microsoft"


}

# CDN Endpoint

resource "azurerm_cdn_endpoint" "ds-cdn-endpoint" {
  name                      = "ds-cdn-${var.env}-endpoint-${random_string.azurerm_cdn_name.result}"
  profile_name              = azurerm_cdn_profile.static-web-cdnprofile.name
  resource_group_name       = var.resource_group_name
  location                  = "Global"
  origin_host_header        = var.static_website_endpoint
  is_http_allowed               = true
  is_https_allowed              = true
  querystring_caching_behaviour = "IgnoreQueryString"
  is_compression_enabled        = true
  content_types_to_compress = [
    "application/eot",
    "application/font",
    "application/font-sfnt",
    "application/javascript",
    "application/json",
    "application/opentype",
    "application/otf",
    "application/pkcs7-mime",
    "application/truetype",
    "application/ttf",
    "application/vnd.ms-fontobject",
    "application/xhtml+xml",
    "application/xml",
    "application/xml+rss",
    "application/x-font-opentype",
    "application/x-font-truetype",
    "application/x-font-ttf",
    "application/x-httpd-cgi",
    "application/x-javascript",
    "application/x-mpegurl",
    "application/x-opentype",
    "application/x-otf",
    "application/x-perl",
    "application/x-ttf",
    "font/eot",
    "font/ttf",
    "font/otf",
    "font/opentype",
    "image/svg+xml",
    "text/css",
    "text/csv",
    "text/html",
    "text/javascript",
    "text/js",
    "text/plain",
    "text/richtext",
    "text/tab-separated-values",
    "text/xml",
    "text/x-script",
    "text/x-component",
    "text/x-java-source",
  ]

  origin {
    name      = "origin"
    host_name   = var.static_website_endpoint
  }
  delivery_rule {
    name  = "EnforceHTTPS"
    order = "1"

    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }
}



