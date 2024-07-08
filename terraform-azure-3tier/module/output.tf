output "frontend_public_ip" {
  description = "Public IP of Frontend (Nginx) Server"
  value       = [azurerm_public_ip.public_ip_nginx.*.ip_address]
}

output "backend_public_ip" {
  description = "Public IP of Backend (Tomcat) Server"
  value       = [azurerm_public_ip.public_ip_tomcat.*.ip_address]
}
