import json
from botocore.exceptions import ClientError
from flask import Flask, jsonify
import os
import boto3

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify({
        "message": "Hello from kubernetes!",
        "app_mode": os.getenv("APP_MODE", "not set"),
        "version": os.getenv("APP_VERSION", "not set")
    })


def get_secret():
    secret_name = "db-secret"
    region_name = "ap-south-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise Exception

    secret_dict = json.loads(get_secret_value_response['SecretString'])
    return secret_dict


@app.route("/secret")
def secret():
    return jsonify({
        "db_password": get_secret()["DB_PASSWORD"]
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
