import asyncio
from typing import Any

from app.services.supabase_service import SupabaseService
from app.services.sumopod_service import SumopodService

class RagServices:
  def __init__(
    self,
    sumopod:SumopodService,
    supabase:SupabaseService,
    retrieval_count:int,
    history_limit:int,
  )->None: #type:ignore
    self.sumopod=sumopod
    self.supabase=supabase
    self.retrieval_count=retrieval_count
    self.history_limit=history_limit
    
  async def answer(
    self,
    session_id:str,
    question:str
  )-> dict: #type:ignore
    query_embedding= await self.sumopod.embed_query(
      question
    )
    
    documents,history= await asyncio.gather(   #type:ignore
      self.supabase.match_documents(
        query_embedding,
        self.retrieval_count,
      ),
      self.supabase.get_history(
        session_id,
        self.history_limit,
      ),
    )
    context="\n\n".join(
      document["content"]
      for document in documents
    )
    messages=[
      {
        "role":"system",
        "content":(
            "Anda adalah asisten RAG. "
            "Jawab hanya pertanyaan TERBARU dari user. "
            "Gunakan history hanya untuk memahami referensi seperti "
            "'itu', 'yang tadi', atau 'jawaban sebelumnya'. "
            "Jangan menjawab ulang pertanyaan lama. "
            "Jangan menggabungkan beberapa pertanyaan menjadi satu jawaban "
            "kecuali pertanyaan terbaru memang memintanya. "
            "Gunakan hanya informasi dari context dokumen. "
            "Jika jawabannya tidak ada dalam context, katakan informasi "
            "tidak ditemukan dalam dokumen.\n\n"
            f"CONTEXT DOKUMEN:\n{context}"
        ),
      },
    ]
    messages.extend(
      {
        "role":item["role"],
        "content":item["content"],
      }
      for item in history
    )
    messages.append(
      {
        "role":"user",
        "content": question,
      }
    )
    answer = await self.sumopod.generate_answer(
      messages
    )
    await asyncio.gather(
      self.supabase.save_messages(
        session_id,
        "user",
        question
      ),
      self.supabase.save_messages(
        session_id,
        "assistant",
        answer
      )
    )
    return{
      "session_id":session_id,
      "answer":answer,
      "sources":[
        {
          "content":document["content"],
          "metadata":document.get("metadata")
        }
        for document in documents
      ],
    }