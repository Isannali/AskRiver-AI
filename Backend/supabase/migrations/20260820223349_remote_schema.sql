create extension if not exists vector;

CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  metadata JSONB,
  embedding VECTOR(1536) -- 1536 dimensi untuk model text-embedding-3-small OpenAI
);

CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id TEXT NOT NULL,
  role TEXT NOT NULL, -- 'user' atau 'assistant'
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_chat_messages_session_created 
ON chat_messages (session_id, created_at ASC);

CREATE OR REPLACE FUNCTION match_documents (
  query_embedding VECTOR(1536),
  match_count INT DEFAULT 5
)
CREATE INDEX IF NOT EXISTS documents_embedding_hnsw_idx 
ON public.documents 
USING hnsw (embedding vector_cosine_ops);

