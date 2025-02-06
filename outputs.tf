
output "minecraft_public_ip" {
  value = aws_eip.minecraft_eip.public_ip
}

output "bot_public_ip" {
  value = aws_instance.discord_bot_instance.public_ip
}