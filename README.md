# AskRiver AI — Minimalist RAG & Chat Memory Web App

[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=flat&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL%20%2B%20pgvector-3ECF8E?style=flat&logo=supabase&logoColor=white)](https://supabase.com/)
[![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

AskRiver AI adalah aplikasi web **Retrieval-Augmented Generation (RAG)** dengan *chat memory*. Upload dokumen PDF (laporan, jurnal, baku mutu air sungai), lalu diskusi multi-turn dengan AI yang menjawab berdasarkan isi dokumen tersebut.

## Features

- 📄 **PDF Ingestion** — ekstraksi teks & chunking otomatis
- 🔍 **Vector Search (RAG)** — pencarian konteks via `pgvector` (cosine similarity)
- 🧠 **Chat Memory** — AI mengingat riwayat percakapan per sesi
- ⚡ **Async Architecture** — non-blocking I/O di FastAPI
- 🎨 **Web UI** — Flutter Web (Phase 2)

## Tech Stack

Python 3.11+ / FastAPI · Supabase (PostgreSQL + pgvector) · Sumopod API (`text-embedding-3-small`, `gpt-5-nano`) · Flutter Web · `pypdf`, `langchain-text-splitters`

## Quick Start

```bash
cd backend
cp .env.example .env        # isi credentials Anda
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Server: `http://127.0.0.1:8000` — API docs interaktif (Swagger): `http://127.0.0.1:8000/docs`

Setup database (SQL schema) & detail konfigurasi lengkap: lihat **[docs/SETUP.md](docs/SETUP.md)**.
Arsitektur & data flow sistem: lihat **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**.

## Project Structure

```
askriver-ai/
├── backend/
│   ├── app/
│   │   ├── api/          # Route handlers / Endpoints
│   │   ├── core/         # Security, environment configs
│   │   ├── models/       # Pydantic schemas & Data Models
│   │   ├── services/     # RAG, Embedding, & Supabase Services
│   │   └── main.py       # FastAPI Entry Point
│   ├── .env.example
│   ├── requirements.txt
│   └── Dockerfile
├── frontend/             # Flutter Web Application (Phase 2)
├── docs/                 # Setup & architecture docs
└── README.md
```
---
Author: Ihsan Aliyandi
