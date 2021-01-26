resource "aws_instance" "backend" {
  count = var.instance_count

  ami                         = var.ami
  instance_type               = var.backend_instance_type
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  vpc_security_group_ids      = [aws_security_group.backend.id]
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
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} -i '${self.public_ip},' --private-key ${var.private_key} -T 300 ../ansible_codes/playbook-backend.yml --extra-vars 'DATABASE_HOST=${aws_db_instance.this.address} DATABASE_USERNAME=${aws_db_instance.this.username}  DATABASE_PASSWORD=${aws_db_instance.this.password} DATABASE_NAME=${aws_db_instance.this.name}'"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "Petclinic-backend-${count.index}"
    }
  )

  depends_on = [
    aws_db_instance.this
  ]
}
