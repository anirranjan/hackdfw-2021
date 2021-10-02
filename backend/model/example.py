from tensorflow import keras
import pickle
model = keras.models.load_model("/kaggle/working/predictor.h5")

dict = pickle.load(open("/kaggle/working/histories_dict.pkl", "rb"))
print(abs(model.predict(dict["MSFT"])[0][0]))
