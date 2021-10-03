import json
from flask import Flask, jsonify, request
from flask_cors import CORS

from tensorflow import keras
import pickle

app = Flask(__name__)
CORS(app)

model = keras.models.load_model("model/predictor.h5")

dict = pickle.load(open("model/histories_dict.pkl", "rb"))

@app.route('/', methods = ['POST'])
def index():
    if request.method == "GET":
        return jsonify({"nothing_to_display": "Nothing to display!"})
    else:
        request_data = json.loads(request.data.decode('utf-8'))
        tag = str(request_data["tag"])
        return jsonify({
            "prediction": str(model.predict(dict[tag])[0][0])
        })

if __name__ == "__main__":
    app.run(debug = True)
