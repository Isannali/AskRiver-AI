from fastapi import APIRouter,File,Depends,UploadFile

from app.schemas.document import UploadResponse
from app.services.pdf_service import PdfService
from app.services.sumopod_service import SumopodService
from app.services.supabase_service import SupabaseService

from app.api.depedencies import Get_Supabase_Service,Get_Pdf_Service,Get_Sumopod_service

router =APIRouter(
  prefix="/documents",
  tags=["Documents"],
)

@router.post(
  "/Upload",
  response_model=UploadResponse
)

async def upload_document(
    file: UploadFile = File(...),
    pdf_service:PdfService = Depends(Get_Pdf_Service),
    sumopod_service:SumopodService = Depends(Get_Sumopod_service),
    supabase_service:SupabaseService = Depends(Get_Supabase_Service)
) -> UploadResponse:

    chunks = await pdf_service.procces_file(file)

    texts = [
        chunk["content"]
        for chunk in chunks
    ]

    embeddings = await sumopod_service.embed_text(texts)

    await supabase_service.insert_documents(
        chunks=chunks,
        embeddings=embeddings,
    )

    upload_response=UploadResponse(
        status="success",
        filename=file.filename or "unknown.pdf",
        total_chunks_processed=len (chunks)
    )
    return upload_response