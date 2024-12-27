import time
import io
import json
import numpy as np
import base64
import pickle
from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from PIL import Image

# Ini buat mulai aplikasi Flask
app = Flask(__name__)

# Nge-load model yang udah kita train sebelumnya
model = load_model("model/model_new.keras")

# Nge-load file label_encoder biar tahu urutan labelnya apa aja
with open("model/label_encoder.pkl", "rb") as file:
    label_encoder = pickle.load(file)

# Mapping label asli (kayak mentah, matang, busuk) ke label Inggris (raw, ripe, rotten)
label_mapping = {
    'mentah': 'raw',
    'matang': 'ripe',
    'busuk': 'rotten'
}

def preprocess_image(img):
    """
    Nih fungsi buat ngerapihin gambar sebelum diprediksi:
    - Dibikin RGB biar aman
    - Diresize jadi ukuran yang pas sama model (128x128)
    - Dinormalisasi (dibagi 255 biar datanya nggak gede banget)
    - Tambahin dimensi batch biar model nggak error
    """
    img = img.convert("RGB")  # Biar formatnya nggak aneh-aneh
    img = img.resize((128, 128))  # Kecil, pas sama input model
    img = np.array(img) / 255.0  # Dibagi 255 biar datanya smooth
    img = np.expand_dims(img, axis=0)  # Tambahin dimensi batch
    return img

@app.route("/predict", methods=["POST"])
def predict():
    try:
        # Cek apakah ada file yang dikirim
        if "file" not in request.files:
            return jsonify({"error": "Please insert file"}), 400

        # Ambil file gambarnya
        file = request.files["file"]
        image = Image.open(file)

        # Timer untuk mengukur waktu prediksi
        start_time = time.time()

        # Preprocess gambar
        processed_image = preprocess_image(image)

        # Prediksi gambar pakai model
        predictions = model.predict(processed_image)
        predicted_class = np.argmax(predictions, axis=1)[0] 
        pred_confidence = predictions[0][predicted_class] * 100 

        # Atur threshold confidence
        confidence_threshold = 87.0

        if pred_confidence < confidence_threshold:
            return jsonify({
                "Prediction Result": "unknown",
                "Confidence": f"{pred_confidence:.2f}",
                "Duration Time": f"{time.time() - start_time:.4f} seconds",
                "Message": "Confidence too low to make a reliable prediction"
            })

        # Konversi dari indeks ke label asli
        predicted_label = label_encoder.inverse_transform([predicted_class])[0]
        pred_label_english = label_mapping.get(predicted_label, "unknown")

        # Mapping label ke pesan konsumsi
        if pred_label_english == 'raw':
            consumption_message = 'Not Yet Suitable for Consumption'
        elif pred_label_english == 'ripe':
            consumption_message = 'Suitable for Consumption'
        elif pred_label_english == 'rotten':
            consumption_message = 'Not Suitable for Consumption'
        else:
            consumption_message = 'Model or prediction not sure'

        # Hitung durasi eksekusi
        duration = time.time() - start_time

        # Bikin respons JSON
        return jsonify({
            "Prediction Result": pred_label_english,
            "Confidence": f"{pred_confidence:.2f}",
            "Duration Time": f"{duration:.4f} seconds",
            "Message": consumption_message
        })

    except Exception as e:
        # Kalau ada error
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    # Jalankan aplikasi di mode debug
    app.run(debug=True)