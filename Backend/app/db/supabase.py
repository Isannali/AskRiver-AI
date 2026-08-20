from supabase import AsyncClient, acreate_client
from app.core.config import Settings

async def create_supabase_client(
  settings:Settings
)->AsyncClient:
  supabase_client= await acreate_client(
    settings.supabase_url,
    settings.supabase_api_key,
  )
  return supabase_client