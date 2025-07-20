# lambda/summary_lambda.py

import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('processed-data')

def lambda_handler(event, context):
    response = table.scan()
    total = len(response['Items'])

    print(f"[{datetime.now()}] Total files processed: {total}")
    return {
        'statusCode': 200,
        'body': f"Total items in DynamoDB: {total}"
    }
