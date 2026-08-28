# AskRiver AI — Minimalist RAG for preserving river ecosystems

[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=flat&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL%20%2B%20pgvector-3ECF8E?style=flat&logo=supabase&logoColor=white)](https://supabase.com/)
[![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)

AskRiver AI adalah aplikasi web **Retrieval-Augmented Generation (RAG)** yang bertujuan untuk memudahkan masyarakat memahami kondisi kesehatan air sungai serta regulasi baku mutu lingkungan di Indonesia. Pengguna cukup bertanya atau mengunggah dokumen tambahan PDF apabila deperlukan (seperti Peraturan Pemerintah, dokumen baku mutu air sungai, atau laporan lingkungan), lalu melakukan diskusi interaktif dengan AI yang menjawab secara presisi berdasarkan isi dokumen tersebut.

## 🎯 Purpose & Vision

- **Menerjemahkan Regulasi & Data:** Menghubungkan data pengukuran fisik (alat IoT) dengan dokumen resmi pemerintah (PP Baku Mutu Air & Pengelolaan Lingkungan).
- **Demokratisasi Informasi:** Memudahkan warga awam mengetahui dan memahami kondisi serta tingkat keamanan air sungai di sekitar mereka secara intuitif melalui percakapan interaktif berbasis AI.

## Features

- 📄 **PDF Ingestion** — ekstraksi teks & chunking otomatis
- 🔍 **Vector Search (RAG)** — Pencarian kemiripan vektor via `pgvector` menggunakan indeks HNSW (Cosine Distance)
- 🧠 **Chat Memory** — AI mengingat riwayat percakapan per sesi
- ⚡ **Async Architecture** — non-blocking I/O di FastAPI
- 🎨 **Web UI** — Flutter Web 

## Tech Stack

Python 3.11+ / FastAPI · Supabase (PostgreSQL + pgvector) · Sumopod API (`text-embedding-3-small`, `gpt-5-nano`) · Flutter Web · `pypdf`, `langchain-text-splitters`

## Quick Start
### 1. Backend (FastAPI)
```bash
cd backend
cp .env.example .env        # Isi credentials Anda
python -m venv venv
source venv/bin/activate    # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
Server: `http://127.0.0.1:8000` — API docs interaktif (Swagger): `http://127.0.0.1:8000/docs`
 
Setup database (SQL schema) & detail konfigurasi lengkap: lihat **[docs/SETUP.md](docs/SETUP.md)**.
Arsitektur & data flow sistem: lihat **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**.
```

### 2. Frontend (flutter)
``` bash
cd frontend
flutter pub get
flutter run -d chrome
```
```text
askriver-ai/
├── backend/
│   ├── app/
│   │   ├── api/          # Route handlers & dependencies
│   │   ├── core/         # Config & Environment settings
│   │   ├── db/           # Supabase client setup
│   │   ├── schemas/      # Pydantic request & response models
│   │   ├── services/     # RAG, PDF processing, & LLM Logic
│   │   └── main.py       # FastAPI Entry Point
│   ├── .env.example      # Environment template
│   └── requirements.txt  # Python dependencies
├── frontend/             # Flutter Web Application
├── docs/                 # Documentation & Architecture
└── README.md             # Project documentation
```
---

Note:
Detail setup database (SQL schema & HNSW Index) dapat dilihat di **[docs/Setup.md](docs/Setup.md)**..
Untuk memahami arsitektur & aliran data sistem dapat dilihat di **[docs/Architecture.md](docs/Architecture.md)**.

Author: Ihsan Aliyandi
