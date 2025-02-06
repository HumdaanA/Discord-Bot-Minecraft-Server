# This here is the PYTHON code for the Lambda function
# Here, it waits for an action from API Gateway, whether it is a stop or start action,
# and starts/stops the MINECRAFT server instance accordingly

# In order to use it, however, when creating the lambda resource in terraform, you must
# compress the file and state the file name in the resource block
# so, this file was zipped into the filed named "lambda_function.zip"


import boto3
import json

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    instance_id = '[MY INSTANCE-ID FOR MINECRAFT SERVER INSTANCE]'  # i left out the ID of the minecraft server instance
    action = event['queryStringParameters']['action']

    if action == 'start':
        ec2.start_instances(InstanceIds=[instance_id])
        return {
            'statusCode': 200,
            'body': json.dumps('Minecraft server started successfully!')
        }
    elif action == 'stop':
        ec2.stop_instances(InstanceIds=[instance_id])
        return {
            'statusCode': 200,
            'body': json.dumps('Minecraft server stopped successfully!')
        }
    else:
        return {
            'statusCode': 400,
            'body': json.dumps('Invalid action! Use start or stop.')
        }
