from fastapi import APIRouter, Request,Depends

from app.schemas.chat import ChatRequest, ChatResponse
from app.services.rag_services import RagServices
from app.services.sumopod_service import SumopodService
from app.services.supabase_service import SupabaseService
from app.api.depedencies import Get_Supabase_Service,Get_Pdf_Service,Get_Sumopod_service,Get_Rag_services

router = APIRouter(
    tags=["Chat"],
)

@router.post(
    "/chat",
    response_model=ChatResponse,
)
async def chat(
  payload: ChatRequest,
  rag_services:RagServices = Depends(Get_Rag_services)
) -> ChatResponse:
    
    result = await rag_services.answer(
        session_id=payload.session_id,
        question=payload.message,
    )

    return ChatResponse(**result)