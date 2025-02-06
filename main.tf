

resource "aws_instance" "minecraft_server" {
  ami           = var.instance_ami
  instance_type = var.minecraft_instance_type
  key_name      = aws_key_pair.server_key.key_name
  tags = {
    Name = "Minecraft Server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y openjdk-17-jre-headless",
      "wget https://launcher.mojang.com/v1/objects/fe5b10f019f7c8483717bda9f7792e0cdb4c05ef/server.jar",
      "echo 'eula=true' > eula.txt",
      "java -Xmx1024M -Xms1024M -jar server.jar nogui &"
    ]
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host     = aws_instance.minecraft_server.public_ip
    }
  }
}

resource "aws_instance" "discord_bot_instance" {
  ami           = var.instance_ami
  instance_type = var.bot_instance_type
  key_name      = aws_key_pair.server_key.key_name
  tags = {
    Name = "Discord Bot Instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y python3 python3-pip",
      "pip3 install discord requests",
      "mkdir -p /home/ec2-user/discord_bot",
      "cd /home/ec2-user/discord_bot",
      "echo 'YOUR_DISCORD_BOT_CODE' > discord_bot.py",
      "nohup python3 discord_bot.py &"
    ]
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host     = aws_instance.discord_bot_instance.public_ip
    }
  }
}

resource "aws_lambda_function" "minecraft_control_lambda" {
  function_name = "MinecraftControlFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "start_stop_instance.lambda_handler"
  runtime       = "python3.8"
  filename      = "lambda_function.zip"
}

resource "aws_apigatewayv2_api" "minecraft_api" {
  name          = "MinecraftControlAPI"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "minecraft_lambda_integration" {
  api_id             = aws_apigatewayv2_api.minecraft_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.minecraft_control_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "minecraft_api_route" {
  api_id    = aws_apigatewayv2_api.minecraft_api.id
  route_key = "ANY /minecraft"
  target    = "integrations/${aws_apigatewayv2_integration.minecraft_lambda_integration.id}"
}

resource "aws_key_pair" "server_key" {
  key_name   = "minecraft_server_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "LambdaExecRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
  name   = "LambdaExecPolicy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:StartInstances", "ec2:StopInstances"],
      "Resource": "*"
    }
  ]
}
EOF
}

output "minecraft_instance_ip" {
  value = aws_instance.minecraft_server.public_ip
}
output "discord_bot_ip" {
  value = aws_instance.discord_bot_instance.public_ip
}
output "api_gateway_endpoint" {
  value = aws_apigatewayv2_api.minecraft_api.api_endpoint
}