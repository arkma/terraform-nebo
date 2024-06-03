resource "aws_vpc" "vnet_nebo" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vnet-nebo"
  }
}

resource "aws_subnet" "snet_public" {
  vpc_id     = aws_vpc.vnet_nebo.id
  cidr_block = "10.0.0.0/17"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "snet-public"
  }
}

resource "aws_subnet" "snet_private" {
  vpc_id     = aws_vpc.vnet_nebo.id
  cidr_block = "10.0.128.0/17"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"
  tags = {
    Name = "snet-private"
  }
}

# resource "aws_security_group" "bastion_sg" {
#   name        = "bastion-sg"
#   description = "Security group for bastion host"
#   vpc_id      = aws_vpc.vnet_nebo.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "BastionSG"
#   }
# }

# resource "aws_security_group" "private_sg" {
#   name        = "private-sg"
#   description = "Security group for private instances"
#   vpc_id      = aws_vpc.vnet_nebo.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     security_groups = [aws_security_group.bastion_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "PrivateSG"
#   }
# }

# resource "aws_instance" "bastion_host" {
#   ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.snet_public.id
#   key_name      = "your-key-pair-name" # Replace with your key pair name
#   security_groups = [aws_security_group.bastion_sg.id]
#   iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

#   tags = {
#     Name = "BastionHost"
#   }
# }

# resource "aws_instance" "private_instance" {
#   ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.snet_private.id
#   key_name      = "your-key-pair-name" # Replace with your key pair name
#   security_groups = [aws_security_group.private_sg.id]

#   tags = {
#     Name = "PrivateInstance"
#   }
# }

# resource "aws_iam_user" "nebo" {
#   name = "nebo"
# }

# resource "aws_iam_role" "ssm_role" {
#   name = "ssm-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ssm_policy" {
#   role       = aws_iam_role.ssm_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
# }

# resource "aws_iam_instance_profile" "ssm_profile" {
#   name = "ssm-profile"
#   role = aws_iam_role.ssm_role.name
# }

# resource "aws_iam_user_policy" "nebo_policy" {
#   name = "nebo-policy"
#   user = aws_iam_user.nebo.name

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "ssm:StartSession",
#         ],
#         Resource = [
#           "arn:aws:ec2:*:*:instance/*",
#           "arn:aws:ssm:*:*:document/AWS-StartSSHSession",
#         ],
#         Condition = {
#           StringEquals = {
#             "ssm:resourceTag/Name": ["BastionHost", "PrivateInstance"]
#           }
#         }
#       },
#       {
#         Effect = "Allow",
#         Action = "iam:CreateServiceLinkedRole",
#         Resource = "*",
#         Condition = {
#           StringEquals = {
#             "iam:AWSServiceName": "ssm.amazonaws.com"
#           }
#         }
#       }
#     ]
#   })
# }



