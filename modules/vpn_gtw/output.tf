output "root_crt" {
  value = file("${var.script_path}/${local.rootca}.crt")
}
  
output "root_key" {
  value = file("${var.script_path}/${local.rootca}.key")
}


output "client_crt" {
  value = file("${var.script_path}/${local.clientcrt}.crt")
}
  
output "client_key" {
  value = file("${var.script_path}/${local.clientcrt}.key")
}
  