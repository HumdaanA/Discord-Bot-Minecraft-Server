# My Minecraft Project!

This project combines several **AWS** services to manage the starting and stopping of a Minecraft server hosted on an EC2 instance. The server can be controlled via a **Discord bot** that listens for /start and /stop commands. These commands are forwarded to an AWS API Gateway endpoint, which then invokes an AWS Lambda function to interact with the EC2 instance.

## Technologies Used
- **AWS EC2** - Hosting the Minecraft server and Discord bot.
- **AWS Lambda** - Triggering EC2 instance start/stop.
- **AWS API Gateway** - Exposing Lambda function as a RESTful API.
- **Discord API** - Managing bot commands.
- **Terraform** - Infrastructure as Code to provision and manage AWS resources.
- **Python** - Backend for both the Discord bot and the Lambda function.

## Different Features of this project
- **Start/Stop Minecraft Server**: Control the state of a Minecraft server running on an EC2 instance with simple Discord commands (/start and /stop).
- **EC2 Instance Management**: Automatically start and stop EC2 instances using a Lambda function.
- **Persistent Discord Bot**: The bot is deployed on an EC2 instance and runs persistently using a systemd service.
- **Infrastructure as Code**: All of the cloud resources (EC2, Lambda, API Gateway, etc.) are provisioned using Terraform.


