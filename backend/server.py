from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/', methods = ['GET'])
def index():
    return jsonify({'greetings' : 'Hello from the Flask server.'})
if __name__ == "__main__":
    app.run(debug = True)