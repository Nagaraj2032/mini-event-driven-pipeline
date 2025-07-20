# lambda/lambda_function.py

import json
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('processed-data')

def lambda_handler(event, context):
    for record in event['Records']:
        file_name = record['s3']['object']['key']
        table.put_item(Item={
            'id': str(uuid.uuid4()),
            'file_name': file_name
        })
    return {
        'statusCode': 200,
        'body': json.dumps('Processed and saved to DynamoDB!')
    }
