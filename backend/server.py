from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/', methods = ['GET'])
def index():
    return jsonify({
        'environmentalScore' : 2431,
        'socialScore': 1343,
        'governanceScore': 972
        })

# Route to get company data for stock viewer page
@app.route('/company', methods = ['GET'])
def getCompany():
    return jsonify({
        'companyName': 'Apple',
        'ticker': 'AAPL',
        'companyType': 'Tech'
    })

if __name__ == "__main__":
    app.run(debug = True)