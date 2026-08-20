from collections.abc import Sequence
from openai import AsyncOpenAI

class SumopodService:
  def __init__(
    self,
    client:AsyncOpenAI,
    embedding_model:str,
    chat_model:str
  )->None:
    self.client=client
    self.embedding_model=embedding_model
    self.chat_model=chat_model
    
  async def embed_text(
    self,
    texts:Sequence[str],
  )->list[list[float]]:
    response=await self.client.embeddings.create(
      model=self.embedding_model,
      input=list(texts)
    )
    items=sorted(
      response.data,
      key=lambda item:item.index
    )
    return [item.embedding for item in items]
  
  async def embed_query(
    self,
    text:str
  )->list[float]:
    embeddings=await self.embed_text([text])
    return embeddings[0]
  
  async def generate_answer(
    self,
    messages:list[dict[str,str]],
  )->str:
    response= await self.client.chat.completions.create(
      model=self.chat_model,
      messages=messages, # type:ignore
      temperature=0.2
    )
    answer= response.choices[0].message.content
    
    if not answer:
      raise RuntimeError("Jawaban dari model kosong")
    
    return answer