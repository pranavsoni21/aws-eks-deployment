from flask import Flask, jsonify
import os

app = Flask(__name__)


@app.route("/")
def home():
	return jsonify({
		"message": "Hello from kubernetes!",
		"app_mode": os.getenv("APP_MODE", "not set"),
		"version": os.getenv("APP_VERSION", "not set")
		})


@app.route("/secret")
def secret():
	return jsonify({
		"db_password": os.getenv("DB_PASSWORD", "not set")
		})


if __name__ == "__main__":
	app.run(host="0.0.0.0", port=5000)