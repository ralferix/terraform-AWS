# spin up servers
resource "aws_instance" "name" {
  
}

# Fleet of application server instances with AWS LB
# Create a new load balancer
resource "aws_elb" "web" {
  name               = "web-elb"
  availability_zones = ["us-west-1a", "us-west-1b", "us-west-1c"]

  access_logs {
    bucket        = "web"
    bucket_prefix = "log"
    interval      = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.web.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "tap-terraform-elb"
  }
}

# Fleet of worker server instances
data "aws_ami" "worker_server_instances" {
  most_recent = true

  filter {
    name   = "ubuntu"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["ralferix"] # Canonical
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.worker_server_instances.id}"
  instance_type = "t2.micro"

  tags = {
    Name = "worker server instance"
  }
}
# Aurora database cluster (MySQL Engine, at least 3 instances)

# Bonus:
# Sensible directory and file structure
# Provide for mapping cloud assets via AWS API (tags)
# Cloudfront
# Terraform modules
# "Precompilation" of terraform code files to allow for more advanced topology patterns.
# Other creative solutions/ideas
