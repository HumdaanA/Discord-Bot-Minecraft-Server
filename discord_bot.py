

import discord
import requests

TOKEN = '[MY DISCORD BOT TOKEN]'   // left out my API Gateway URL & Discord Token
API_GATEWAY_URL = '[MY API GATEWAY URL]'

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
