import json
ticker = "AAPL"
reuters = {i[:i.index(".")]: j for i, j in json.loads(open("/kaggle/input/reuters/reuters_data.json", "r").read()).items() if "." in i and any(c.isalpha() for c in i[:i.index(".")])}
prediction = model.predict(d[name][:-1])[0][0]
future_esg = reuters["AAPL"]["esgScore"]["TR.TRESG"]["score"] * (1 + prediction / 2)
