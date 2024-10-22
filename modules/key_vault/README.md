How to use this module
======================
This module reads a DNS zone in Azure.

Copy this folder under a terragrunt folder of the piece of infra that needs DNS configuration (for example `environments/test/westeurope/bff`).

Add the dependency to this module in the application's `terragrunt.hcl` file:
```hcl
dependency "dns" {
  config_path = "../dns"
}
```
In the application's component (in `terraform/components/bff`) add a `dns.tf` file with the records you want to add to the DNS zone, for example:
```hcl
resource "azurerm_dns_a_record" "bff" {
  name                = "bff"
  zone_name           = dependency.dns.outputs.zone_name
  resource_group_name = dependency.dns.outputs.resource_group_name
  ttl                 = 300
  records             = [azurerm_public_ip.bff.ip_address]
}
```

Next time the application will be deployed, terragrunt will read the zone properties and add the records you specified.
