from functools import lru_cache
from pydantic_settings import BaseSettings,SettingsConfigDict

class Settings(BaseSettings):
  supabase_url:str
  supabase_api_key:str
  
  sumopod_api_key:str
  sumopod_base_url:str
  
  embedding_model:str
  chat_model:str
  
  cors_origins:str
  chunk_size:int
  chunk_overlap:int
  retrieval_count:int
  history_limit:int
  max_file_size:int
  
  model_config=SettingsConfigDict(
    env_file=".env",
    env_file_encoding="utf-8",
    extra="ignore",
  )
  
@lru_cache # ini biar ga usah ngambil atau baca lagi env dari awal kalo panggil get_settings
def get_settings()->Settings:
  settings=Settings()  #type:ignore
  return settings