from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from pydantic import BaseModel, EmailStr
from database import get_db
import auth

app = FastAPI(title="Mundo Cristão API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class UsuarioCadastro(BaseModel):
    nome: str
    email: EmailStr
    senha: str
    cidade: str
    estado: str

class UsuarioLogin(BaseModel):
    email: EmailStr
    senha: str

@app.get("/")
def home():
    return {"status": "API Mundo Cristão rodando com sucesso!"}

@app.post("/auth/cadastro", status_code=status.HTTP_201_CREATED)
def cadastrar_usuario(usuario: UsuarioCadastro, db: Session = Depends(get_db)):
    senha_criptografada = auth.gerar_hash_senha(usuario.senha)
    token = auth.criar_token_acesso({"sub": usuario.email})
    return {
        "mensagem": "Usuário cadastrado com sucesso!",
        "access_token": token,
        "token_type": "bearer"
    }

@app.post("/auth/login")
def login(usuario: UsuarioLogin, db: Session = Depends(get_db)):
    token = auth.criar_token_acesso({"sub": usuario.email})
    return {
        "access_token": token,
        "token_type": "bearer"
    }
