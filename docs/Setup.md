# Setup Guide

## Prerequisites

- Python 3.11 atau lebih baru
- Akun Supabase dengan proyek aktif
- API Key dari Sumopod / OpenAI

---

## 1. Database Setup (Supabase)

Jalankan script SQL berikut pada **SQL Editor** di dashboard Supabase Anda:

```sql
-- 1. Aktifkan ekstensi pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Tabel untuk menyimpan vektor dokumen (RAG Knowledge Base)
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  metadata JSONB,
  embedding VECTOR(1536) -- 1536 dimensi untuk text-embedding-3-small
);

-- 3. Tabel untuk menyimpan riwayat chat (Chat Memory)
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id TEXT NOT NULL,
  role TEXT NOT NULL, -- 'user' atau 'assistant'
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Indeks HNSW untuk mempercepat Vector Similarity Search (Cosine Distance)
CREATE INDEX ON documents 
USING hnsw (embedding vector_cosine_ops);

-- 5. RPC Function untuk Vector Similarity Search (Cosine Distance)
CREATE OR REPLACE FUNCTION match_documents (
  query_embedding VECTOR(1536),
  match_count INT DEFAULT 5
)
RETURNS TABLE (
  id UUID,
  content TEXT,
  metadata JSONB,
  similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    documents.id,
    documents.content,
    documents.metadata,
    1 - (documents.embedding <=> query_embedding) AS similarity
  FROM documents
  ORDER BY documents.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;
```

---

## 2. Environment Setup

```bash
cd backend
cp .env.example .env
```

Isi file `.env` dengan kredensial proyek Anda:

```env
SUPABASE_URL=[https://your-supabase-project.supabase.co](https://your-supabase-project.supabase.co)
SUPABASE_SERVICE_ROLE_KEY=your-supabase-service-role-key
SUMOPOD_API_KEY=your-sumopod-api-key
SUMOPOD_BASE_URL=[https://api.sumopod.com/v1](https://api.sumopod.com/v1)
```

---

## 3. Installation & Local Execution

```bash
# Buat dan aktifkan virtual environment
python -m venv venv
source venv/bin/activate   # Linux/macOS
# venv\Scripts\activate    # Windows (CMD)

# Install dependensi
pip install -r requirements.txt

# Jalankan server FastAPI
uvicorn app.main:app --reload
```

Server akan berjalan pada: `http://127.0.0.1:8000`

---

## API Reference

Dokumentasi OpenAPI/Swagger otomatis tersedia di `http://127.0.0.1:8000/docs` setelah server berjalan.

### Endpoints Summary

#### 1. Upload & Process PDF
- **Endpoint:** `POST /api/v1/documents/upload`
- **Content-Type:** `multipart/form-data`
- **Body:** `file` (File PDF)
- **Detail:** Melakukan ekstraksi teks, *chunking* (`chunk_size=1000`, `chunk_overlap=200`), membuat *vector embedding*, dan menyimpannya ke Supabase.

#### 2. Chat with RAG & Memory
- **Endpoint:** `POST /api/v1/chat`
- **Content-Type:** `application/json`
- **Body:**
  ```json
  {
    "session_id": "session_demo_001",
    "message": "Apa kesimpulan utama dari dokumen tersebut?"
  }
  ```
- **Detail:** Mengambil konteks dokumen paling relevan via HNSW Vector Search + riwayat percakapan sebelumnya, lalu menghasilkan jawaban dari LLM.