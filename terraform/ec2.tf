#creating EC2 instance
resource "aws_instance" "Nagesh-ec2" {
  ami                         = "ami-0432c2005d3e6a7f4" #Amazon linux 2 AMI
  key_name                    = "kmaster"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.lab-Public-SG.id]
  user_data                   = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        systemctl start httpd
        systemctl enable httpd
        echo "<html><body><h1>Design and implement a CI/CD pipeline that builds, tests and deploys a single-page web application by Nagesha </h1></body></html>" > /var/www/html/index.html
        EOF
  tags = {
    Name = "nagesh-EC2"
  }
}
