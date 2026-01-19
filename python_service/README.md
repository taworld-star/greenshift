# GreenShift - Python ML Service

Service AI untuk klasifikasi sampah menggunakan model Keras yang ditraining dengan Teachable Machine.

## Teknologi

- Flask 3.x - Web framework
- TensorFlow/Keras - Machine Learning
- Pillow - Image processing

## Model

Model mengklasifikasikan gambar ke dalam 3 kategori:
- **Organik** - Sampah yang dapat terurai (sisa makanan, daun, dll)
- **Anorganik** - Sampah yang sulit terurai (plastik, kaca, logam)
- **B3** - Bahan Berbahaya dan Beracun (baterai, elektronik, dll)

File model:
- `keras_model.h5` - Model terlatih
- `labels.txt` - Label kategori

## Instalasi

```bash
cd python_service
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # Linux/Mac
pip install flask flask-cors tf-keras pillow numpy
```

## Menjalankan

```bash
python app.py
```
Server berjalan di `http://localhost:5000`

## API Endpoints

### GET /
Health check server.

**Response:**
```json
{
  "status": "online",
  "message": "Server AI GreenShift Jalan!",
  "model_loaded": true
}
```

### POST /predict
Klasifikasi gambar sampah.

**Request:**
- Method: POST
- Content-Type: multipart/form-data
- Body: `file` atau `image` (file gambar)

**Response:**
```json
{
  "success": true,
  "data": {
    "category": "organik",
    "label": "Sampah organik yang dapat terurai secara alami.",
    "confidence": "0.9523",
    "tips": "Bisa dijadikan pupuk kompos. Buang ke tong sampah HIJAU."
  },
  "all_predictions": {
    "organik": 0.9523,
    "non organik": 0.0412,
    "b3": 0.0065
  }
}
```
