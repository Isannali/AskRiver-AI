from pydantic import BaseModel

class UploadResponse(BaseModel):
  status:str
  filename:str
  total_chunks_processed:int
  
  