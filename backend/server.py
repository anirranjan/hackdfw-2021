import json
import yfinance as yf

from flask import Flask, jsonify, request
from flask_cors import CORS

from tensorflow import keras
import pickle

app = Flask(__name__)
CORS(app)

model = keras.models.load_model("model/predictor.h5")

dict = pickle.load(open("model/histories_dict.pkl", "rb"))

reuters = {i[:i.index(".")]: j for i, j in json.loads(open("model/reuters_data.json", "r").read()).items() if "." in i and any(c.isalpha() for c in i[:i.index(".")])}

@app.route('/', methods = ['POST'])
def index():
    if request.method == "GET":
        return jsonify({"nothing_to_display": "Nothing to display!"})
    else:
        request_data = json.loads(request.data.decode('utf-8'))
        tag = str(request_data["tag"]).upper()
        return jsonify(get_scores(tag))

@app.route("/portfolio_stats", methods=["POST"])
def portfolio_stats():
    request_data = json.loads(request.data.decode('utf-8'))
    tags = [str(s).upper() for s in request_data["tags"]]
    return jsonify(get_portfolio_average(tags))

def get_portfolio_average(tags):
    out = {"prediction": 0, "environmentalScore": 0, "socialScore": 0, "governanceScore": 0, "delta": 0}
    for tag in tags:
        try:
            for k, v in get_scores(tag).items():
                out[k] += v
        except:
            print("Couldn't get stuff for", tag)
    out = {k: int(v / len(tags)) for k, v in out.items()}
    return out

def get_scores(tag):
    prediction = model.predict(dict[tag])[0][0]
    future_esg = reuters[tag]["esgScore"]["TR.TRESG"]["score"] * (1 + prediction / 2) if tag in reuters.keys() else f"We're still gathering data on {tag}. Check back later!"

    escore, sscore, gscore = reuters[tag]["esgScore"]["TR.EnvironmentPillar"]["score"], reuters[tag]["esgScore"]["TR.SocialPillar"]["score"], reuters[tag]["esgScore"]["TR.GovernancePillar"]["score"]
    escore, sscore, gscore = (escore * (1 + prediction / 2)), (sscore * (1 + prediction / 2)), (gscore * (1 + prediction / 2))

    return {
        "prediction": round(future_esg, 2),
        "environmentalScore": escore,
        "socialScore": sscore,
        "governanceScore": gscore,
        "delta": future_esg - reuters[tag]["esgScore"]["TR.TRESG"]["score"]
    }

# Route to get company data for stock viewer page
@app.route('/company', methods = ['POST'])
def getCompany():
    request_data = json.loads(request.data.decode('utf-8'))
    tag = str(request_data["tag"]).upper()

    tinfo = yf.Ticker(tag).info

    x = {
        'companyName': tinfo["longName"],
        'ticker': tag,
        'companyType': tinfo["industry"]
    }

    x.update(get_scores(tag))

    return jsonify(x)

if __name__ == "__main__":
    app.run(debug = True)
