import boto3
import json

lambda_client = boto3.client("lambda")


def call_lambda(function_name, payload=None):
    try:
        response = lambda_client.invoke(
            FunctionName=function_name,
            InvocationType='RequestResponse',
            Payload=json.dumps(payload or {})
        )
        result = response['Payload'].read().decode("utf-8")
        return json.loads(result)
    except Exception as e:
        return {"error": str(e)}
