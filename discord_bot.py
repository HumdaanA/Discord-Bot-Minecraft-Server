# This is the PYTHON code for the discord bot

# in order to use it, you have to go to the Discord Developer Portal and create a new application
# there, you can create a bot and invite it to your discord server



import discord
import requests

TOKEN = 'DISCORD_BOT_TOKEN'   # Discord Bot token and API Gateway URL set up in ENV Variables
API_GATEWAY_URL = 'API_GATEWAY_URL'

intents = discord.Intents.default()
intents.messages = True

client = discord.Client(intents=intents)

@client.event
async def on_message(message):
    if message.author == client.user:
        return

    if message.content.startswith('/start'):
        response = requests.post(f"{API_GATEWAY_URL}?action=start")
        await message.channel.send(response.json())

    elif message.content.startswith('/stop'):
        response = requests.post(f"{API_GATEWAY_URL}?action=stop")
        await message.channel.send(response.json())

client.run(TOKEN)
