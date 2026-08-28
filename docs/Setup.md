# Setup Guide

## Prerequisites

- Python 3.11 atau lebih baru
- Akun Supabase dengan proyek aktif
- API Key dari Sumopod / OpenAI

## 1. Database Setup (Supabase)

Jalankan script SQL berikut pada SQL Editor di dashboard Supabase Anda:

```sql
-- 1. Aktifkan ekstensi pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Tabel untuk menyimpan vektor dokumen (RAG Knowledge Base)
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  metadata JSONB,
  embedding VECTOR(1536)
);

-- 3. Tabel untuk menyimpan riwayat chat (Chat Memory)
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id TEXT NOT NULL,
  role TEXT NOT NULL, -- 'user' atau 'assistant'
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. RPC Function untuk Vector Similarity Search (Cosine Distance)
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

## 2. Environment Setup

```bash
cd backend
cp .env.example .env
```

Isi file `.env`:

```env
SUPABASE_URL=https://your-supabase-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-supabase-service-role-key
SUMOPOD_API_KEY=your-sumopod-api-key
SUMOPOD_BASE_URL=https://api.sumopod.com/v1
```

## 3. Installation & Local Execution

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

pip install -r requirements.txt

uvicorn app.main:app --reload
```

Server berjalan pada `http://127.0.0.1:8000`.

## API Reference

Dokumentasi OpenAPI/Swagger otomatis tersedia di `http://127.0.0.1:8000/docs` setelah server jalan — selalu sinkron dengan kode, jadi jadi sumber kebenaran utama untuk request/response schema.

### Ringkasan endpoint utama

**Upload & Process PDF**
`POST /api/v1/documents/upload` · `multipart/form-data` · body: `file` (PDF)
Melakukan chunking (`chunk_size=1000`, `chunk_overlap=200`), membuat embedding, simpan ke Supabase.

**Chat with RAG & Memory**
`POST /api/v1/chat` · `application/json`
```json
{
  "session_id": "session_demo_001",
  "message": "Apa kesimpulan utama dari dokumen tersebut?"
}
```
Mengambil konteks dokumen relevan + riwayat percakapan, lalu menghasilkan jawaban LLM.