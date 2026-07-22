from passlib.context import CryptContext
from jose import jwt

SECRET_KEY = "sua-chave-secreta-super-segura"
ALGORITHM = "HS256"

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def gerar_hash_senha(senha: str):
    return pwd_context.hash(senha)

def verificar_senha(senha_plana: str, senha_hash: str):
    return pwd_context.verify(senha_plana, senha_hash)

def criar_token_acesso(dados: dict):
    dados_codificados = dados.copy()
    return jwt.encode(dados_codificados, SECRET_KEY, algorithm=ALGORITHM)
