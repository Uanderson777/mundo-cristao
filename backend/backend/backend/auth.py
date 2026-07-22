from datetime import datetime, timedelta
from typing import Optional
import jwt
from passlib.context import CryptContext

SECRET_KEY = "sua_chave_secreta_super_segura_mundo_cristao"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def gerar_hash_senha(senha: str) -> str:
    return pwd_context.hash(senha)

def verificar_senha(senha_plana: str, senha_hash: str) -> bool:
    return pwd_context.verify(senha_plana, senha_hash)

def criar_token_acesso(dados: dict, expira_em: Optional[timedelta] = None) -> str:
    para_codificar = dados.copy()
    expire = datetime.utcnow() + (expira_em or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    para_codificar.update({"exp": expire})
    return jwt.encode(para_codificar, SECRET_KEY, algorithm=ALGORITHM)
