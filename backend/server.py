import json
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
        tag = str(request_data["tag"])
        
        prediction = model.predict(dict[tag])[0][0]
        future_esg = reuters[tag]["esgScore"]["TR.TRESG"]["score"] * (1 + prediction / 2) if tag in reuters.keys() else f"We're still gathering data on {tag}. Check back later!"
        
        return jsonify({
            "prediction": future_esg
        })

if __name__ == "__main__":
    app.run(debug = True)
