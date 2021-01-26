output "db-address" {
  value = aws_db_instance.this.address
}

output "db-endpoints" {
  value = aws_db_instance.this.endpoint
}

output "db-name" {
  value = aws_db_instance.this.name
}

output "aws_public_subnet" {
  value = aws_subnet.public.*.id
}

output "aws_private_subnet" {
  value = aws_subnet.private.*.id
}

output "frontend_clb_fqdn" {
  value = aws_elb.frontend_clb.dns_name
}

output "backend_clb_fqdn" {
  value = aws_elb.backend_clb.dns_name
}

output "petclinic_backend_ip" {
  value = aws_instance.backend[*].public_ip
}

output "petclinic_frontend_ip" {
  value = aws_instance.frontend[*].public_ip
}
