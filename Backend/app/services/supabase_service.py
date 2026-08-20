from supabase import AsyncClient

class SupabaseService:
  def __init__(
    self,
    client:AsyncClient
  ):
    self.client=client
  
  async def insert_documents (
    self,
    chunks: list[dict],
    embeddings:list[list[float]]
  )->None:
    rows=[
      {
        "content": chunk["content"],
        "metadata": chunk["metadata"],
        "embedding": embedding,
      }
      for chunk,embedding in zip(chunks,embeddings)
    ]
    await(
      self.client
      .table("documents")
      .insert(rows)
      .execute()
    )
    
  async def match_documents(
    self,
    query_embedding:list[float],
    match_count:int
  )->list[dict]:
    response= await self.client.rpc(
      "match_documents",
      {
        "query_embedding": query_embedding,
        "match_count": match_count,
      },
    ).execute()
    return response.data or [] #type:ignore
  
  async def get_history(
    self,
    session_id:str,
    limit:int
  )->list[dict]: #type:ignore
    response= await (
      self.client
      .table("chat_messages")
      .select("role,content,created_at")
      .eq("session_id",session_id)
      .order("created_at", desc=True)
      .limit(limit)
      .execute()
    )
    history= list(reversed(response.data or []))
    return history # type:ignore
  
  async def save_messages(
    self,
    session_id:str,
    role:str,
    content:str,
  )->None:
    await(
      self.client
      .table("chat_messages")
      .insert(
        {
          "session_id":session_id,
          "role":role,
          "content":content,
        }
      ).execute()
    )
    