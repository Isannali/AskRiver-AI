import asyncio
from io import BytesIO

from fastapi import HTTPException,UploadFile
from langchain_text_splitters import RecursiveCharacterTextSplitter
from pypdf import PdfReader

class PdfService:
  def __init__(
    self,
    chunk_size:int,
    chunk_overlap:int,
    max_file_size:int,
  )->None:
    self.max_file_size=max_file_size
    self.splitter=RecursiveCharacterTextSplitter(
      chunk_size=chunk_size,
      chunk_overlap=chunk_overlap,
    )
  
  async def procces_file(
    self,
    file:UploadFile,
  )-> list[dict]:
    filename=file.filename or ""
    if not filename.lower().endswith(".pdf"):
      raise HTTPException(
        status_code=400,
        detail="File harus berformat PDF",
      )
    file_bytes=await file.read()
    if len (file_bytes)> self.max_file_size:
      raise HTTPException(
        status_code=413,
        detail="Ukuran file maksimal melebihi"
      )
      
    try:
      pages= await asyncio.to_thread(
        self.extract_pages,
        file_bytes
        )
    except Exception as error:
      raise HTTPException(
        status_code=400,
        detail="PDF tidak bisa diproses"
      ) from error
    
    chunks=[]
    
    for page_number,text in pages:
      page_chunks= await asyncio.to_thread(
        self.splitter.split_text,
        text,
      )
      for content in page_chunks:
        chunks.append(
          {
            "content":content,
            "metadata":{
              "filename":filename,
              "page":page_number,
            },
          }
        )
    if not chunks:
      raise HTTPException(
        status_code=400,
        detail="PDF tidak punya teks"
      )
    return chunks
  
  @staticmethod
  def extract_pages(
    file_bytes:bytes,
  )-> list [tuple[int,str]]:
    reader=PdfReader(BytesIO(file_bytes))
    pages=[]
    
    for page_number , page in enumerate(
      reader.pages,
      start=1
    ):
      text=(page.extract_text()or "").strip()
      
      if text:
        pages.append((page_number,text))
        
    return pages

    
    
