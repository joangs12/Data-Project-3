from flask import Flask, render_template, request, redirect, url_for
import boto3
import json

app = Flask(__name__)

lambda_client = boto3.client('lambda', region_name='eu-central-1')

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/movie/<int:movie_id>")
def movie_detail():
    payload = request.args.to_dict()
    response = lambda_client.invoke(
        FunctionName='src',
        InvocationType='RequestResponse',
        Payload=json.dumps(payload)
    )
    result = response['Payload'].read()
    print(result)
    return result

@app.route("/add", methods=["POST"])
def add_movie():
    return "Movie added successfully!"

if __name__ == "__main__":
     app.run(host='0.0.0.0', port=8080, debug=True)