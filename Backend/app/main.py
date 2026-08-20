from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import get_settings
from app.db.supabase import create_supabase_client
from app.api.routers import chat,document
from openai import AsyncOpenAI


settings=get_settings()

@asynccontextmanager
async def lifespan(
  app:FastAPI
):

  app.state.settings=settings
  app.state.supabase=await create_supabase_client(
    settings,
  )
  app.state.sumopod=AsyncOpenAI(
    api_key=settings.sumopod_api_key,
    base_url=settings.sumopod_base_url.rstrip("/"),
    timeout=60.0,
    max_retries=2,
  )
  yield
  
  await app.state.sumopod.close()


app = FastAPI(
  title="Askriver AI",
  version="1.0.0",
  lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        origin.strip()
        for origin in settings.cors_origins.split(",")
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(
  document.router,
  prefix="/api/v1"
)

app.include_router(
  chat.router,
  prefix="/api/v1",
)