import os
import numpy as np
from flask import Flask, request, jsonify
from flask_cors import CORS
import tf_keras as keras
from PIL import Image, ImageOps

app = Flask(__name__)
CORS(app) # Agar bisa diakses dari luar (Laravel/Flutter)

# KONFIGURASI 
MODEL_PATH = 'keras_model.h5'
LABELS_PATH = 'labels.txt'


# DESCRIPTIONS & TIPS 
DESCRIPTIONS = {
    'organik': 'Sampah organik yang dapat terurai secara alami.',
    'anorganik': 'Sampah anorganik/non-organik sulit terurai.',
    'b3': 'Sampah B3 (Bahan Berbahaya & Beracun).'
}

DISPOSAL_METHODS = {
    'organik': 'Bisa dijadikan pupuk kompos atau pakan maggot. Buang ke tong sampah HIJAU.',
    'anorganik': 'Pastikan bersih, lalu kumpulkan untuk didaur ulang (Bank Sampah). Buang ke tong KUNING.',
    'b3': 'BAHAYA! Jangan dibuang sembarangan. Pisahkan wadah tertutup dan serahkan ke petugas khusus.'
}

# LOAD MODEL 
print(" Loading AI Model...")
try:
    model = keras.models.load_model(MODEL_PATH, compile=False)
    print("Model suskes dimuat.")
except Exception as e:
    print(f"Eror saat memuat model: {e}")
    model = None

# LOAD LABELS
try:
    with open(LABELS_PATH, 'r') as f:
        labels = [line.strip() for line in f.readlines()]
    print(f"Labels berhasil dimuat: {labels}")
except Exception as e:
    print(f"Eror saat memuat labels: {e}")
    labels = ['0 organik', '1 anorganik', '2 b3'] # Default fallback

    
def preprocess_image(image):
    # 1. Membuka gambar & mengubah ke RGB
    image = image.convert("RGB")
    
    # 2. Size ke 224x224 (Standar Teachable Machine)
    size = (224, 224)
    image = ImageOps.fit(image, size, Image.Resampling.LANCZOS)
    
    # 3. Mengubah ke array & Normalisasi
    image_array = np.asarray(image)
    normalized_image_array = (image_array.astype(np.float32) / 127.5) - 1
    
    # 4. Membuat batch dimension
    data = np.ndarray(shape=(1, 224, 224, 3), dtype=np.float32)
    data[0] = normalized_image_array
    return data

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        "status": "online",
        "message": "Server AI GreenShift Jalan! Gunakan POST /predict untuk upload.",
        "model_loaded": model is not None,
    })

@app.route('/predict', methods=['POST'])
def predict():
    if model is None:
        return jsonify({'success': False, 'error': 'Model not loaded'}), 500
    
    # Support key 'file' (Postman default) ATAU 'image'
    if 'file' in request.files:
        image_file = request.files['file']
    elif 'image' in request.files:
        image_file = request.files['image']
    else:
        return jsonify({'success': False, 'error': 'No image provided (use key: file)'}), 400
    
    try:
        # Open Image
        image = Image.open(image_file.stream)
        
        # Preprocess
        processed_image = preprocess_image(image)
        
        # Predict
        predictions = model.predict(processed_image)
        
        # Get Top Result
        class_index = np.argmax(predictions[0])
        confidence = float(predictions[0][class_index])
        raw_label = labels[class_index]
        
        # DEBUG LOGGING
        print(f"=== DEBUG PREDICTION ===")
        print(f"Raw predictions: {predictions[0]}")
        print(f"Class index: {class_index}")
        print(f"Confidence: {confidence}")
        print(f"Raw label: '{raw_label}'")
        print(f"========================")
        
        # CLEANING LABEL 
        # Mengubah "0 Organik" menjadi "organik"
        # Mengubah "1 Non Organik" menjadi "anorganik"
        # Mengubah "2 B3" menjadi "b3"
        clean_label = raw_label.lower().strip()
        
        # hanya angka prefix dan spasi (misal "0 ", "1 ", "2 ")
        # Jangan hapus angka di dalam kata seperti "b3"
        if len(clean_label) > 2 and clean_label[0].isdigit() and clean_label[1] == ' ':
            clean_label = clean_label[2:].strip()
        
        print(f"Clean label: '{clean_label}'")  # Debug
            
        # Normalisasi nama - PENTING: cek B3 DULU sebelum organik!
        if "b3" in clean_label or "b 3" in clean_label or clean_label == "b3":
            final_key = "b3"
        elif "non" in clean_label or "anorganik" in clean_label:
            final_key = "anorganik"
        elif "organik" in clean_label:
            final_key = "organik"
        else:
            final_key = "unknown"
        
        print(f"Final key: '{final_key}'")  # Debug

        # BUILD ALL PREDICTIONS
        # Membuat daftar persentase untuk semua kemungkinan
        all_preds = {}
        for i, label_name in enumerate(labels):
            # Bersihkan nama label untuk display
            clean_name = label_name.lower()
            for k in range(10): clean_name = clean_name.replace(str(k), "").strip()
            
            # Memasukkan ke dictionary
            score = float(predictions[0][i])
            all_preds[clean_name] = round(score, 4)

        # Prepare Response 
        response = {
            'success': True,
            'data': {
                'category': final_key,  # 'organik', 'anorganik', atau 'b3'
                'label': DESCRIPTIONS.get(final_key, 'Kategori tidak dikenali'),
                'confidence': str(round(confidence, 4)),
                'tips': DISPOSAL_METHODS.get(final_key, 'Hubungi petugas kebersihan.'),
            },
            'all_predictions': all_preds  
        }
        
        return jsonify(response), 200
        
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

if __name__ == '__main__':
    print("="*50)
    print("GreenShift AI Service Started")
    print(f"Model: {MODEL_PATH}")
    print("="*50)
    app.run(debug=True, host='0.0.0.0', port=5000)