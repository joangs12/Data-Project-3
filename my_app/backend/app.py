from flask import Flask, request, jsonify
import os
from lambda_client import call_lambda

app = Flask(__name__)

LAMBDA_LIST = "getelement"
LAMBDA_ADD = "addproduct"
LAMBDA_CART = "buy_product"
LAMBDA_SETUP = "setup"
SETUP_SECRET = "admin123"


@app.route("/setup", methods=["GET"])
def setup():
    token = request.args.get("token")
    if token != SETUP_SECRET:
        return jsonify({"error": "Unauthorized"}), 401
    result = call_lambda(LAMBDA_SETUP)
    return jsonify(result)


@app.route("/movies", methods=["GET"])
def list_movies():
    result = call_lambda(LAMBDA_LIST)
    return jsonify(result)


@app.route("/add", methods=["POST"])
def add_movie():
    data = request.get_json()
    result = call_lambda(LAMBDA_ADD, payload=data)
    return jsonify(result)


@app.route("/cart", methods=["POST"])
def add_to_cart():
    data = request.get_json()
    result = call_lambda(LAMBDA_CART, payload=data)
    return jsonify(result)
