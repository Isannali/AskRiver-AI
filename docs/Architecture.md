# System Architecture & Data Flow

```text
=================== 1. INGESTION PIPELINE ===================
[Client / Flutter Web] ──(POST PDF File)──> FastAPI
                                            │
                                            ├── 1. Extract Text (pypdf)
                                            ├── 2. Chunk Text (RecursiveCharacterTextSplitter)
                                            ├── 3. Generate Embeddings (Sumopod / OpenAI)
                                            └── 4. Save to Supabase (`documents`)

==================== 2. INFERENCE PIPELINE ====================
[Client / Flutter Web] ──(POST Query)──> FastAPI
                                           │
                                           ├── 1. Embed Query & Match Similarity ──> Supabase (`documents`)
                                           ├── 2. Fetch Chat History (WHERE session) ──> Supabase (`chat_messages`)
                                           ├── 3. Combine Context + History + Query ──> LLM (Sumopod OpenAI)
                                           ├── 4. Save User & Assistant Message ──> Supabase (`chat_messages`)
                                           └── 5. Return JSON Response ──────────> Client
```

## Notes
- **Ingestion** menyimpan konten sumber sebagai vektor 1536 dimensi di kolom `embedding` (tabel `documents`), sehingga bisa dicari lewat cosine distance (`<=>` operator pgvector).
- **Inference** menggabungkan tiga sumber konteks sebelum dikirim ke LLM: (1) hasil similarity search dari dokumen, (2) riwayat chat per `session_id`, (3) pertanyaan user saat ini.
- Fungsi `match_documents` (lihat [SETUP.md](SETUP.md)) menangani similarity search di sisi database lewat RPC call, bukan di application layer — lebih cepat karena index vector di-handle langsung oleh Postgres/pgvector.