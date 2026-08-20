from fastapi import Request
from app.services.supabase_service import SupabaseService
from app.services.pdf_service import PdfService
from app.services.sumopod_service import SumopodService
from app.services.rag_services import RagServices

def Get_Pdf_Service(
  request:Request,
)-> PdfService: #type:ignore
  settings=request.app.state.settings 
  get_pdf_service= PdfService(
    chunk_size=settings.chunk_size,
    chunk_overlap=settings.chunk_overlap,
    max_file_size=settings.max_file_size
  )
  return get_pdf_service

def Get_Sumopod_service(
  request:Request,
)-> SumopodService: #type:ignore
  settings=request.app.state.settings 
  get_sumopod_service=SumopodService(
    client=request.app.state.sumopod,
    embedding_model=settings.embedding_model,
    chat_model=settings.chat_model,  
  )
  return get_sumopod_service
  
def Get_Supabase_Service(
  request:Request
):
  get_supabase_service=SupabaseService(
    client=request.app.state.supabase
  )
  return get_supabase_service

def Get_Rag_services(
  request:Request
):
  settings= request.app.state.settings 
  get_rag_services= RagServices(
    sumopod=Get_Sumopod_service(request),
    supabase=Get_Supabase_Service(request),
    retrieval_count= settings.retrieval_count,
    history_limit=settings.history_limit,
  )
  return get_rag_services
  