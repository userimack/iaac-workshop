resource "aws_instance" "frontend" {
  count = var.instance_count

  ami                         = var.ami
  instance_type               = var.frontend_instance_type
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  vpc_security_group_ids      = [aws_security_group.frontend.id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  # Ansible requires Python to be installed on the remote machine as well as the local machine.
  provisioner "remote-exec" {
    inline = ["sudo apt update && sudo apt -qq install python3-minimal -y"]
  }

  connection {
    type        = "ssh"
    host        = coalesce(self.public_ip, self.private_ip)
    private_key = file(var.private_key)
    user        = var.ansible_user
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} -i '${self.public_ip},' --private-key ${var.private_key} -T 300 ../ansible_codes/playbook-frontend.yml --extra-vars 'BACKEND_URL=${aws_elb.backend_clb.dns_name}'"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "Petclinic-fr-${count.index}"
    }
  )

  depends_on = [
    aws_db_instance.this,
    aws_elb.backend_clb
  ]
}
