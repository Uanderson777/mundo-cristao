-- =======================================================
-- MUNDO CRISTÃO - Estrutura do Banco de Dados (PostgreSQL)
-- =======================================================

-- Habilitar extensão para geração de UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -------------------------------------------------------
-- 1. TABELA DE USUÁRIOS E AUTENTICAÇÃO
-- -------------------------------------------------------
CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    pais VARCHAR(50) DEFAULT 'Brasil',
    igreja VARCHAR(120),
    denominacao VARCHAR(80),
    estado_civil VARCHAR(30),
    foto_perfil VARCHAR(255),
    sobre_mim TEXT,
    o_que_procura TEXT,
    e_premium BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- 2. TABELA DE PREFERÊNCIAS DE NAMORO (MATCHING)
-- -------------------------------------------------------
CREATE TABLE preferencias_namoro (
    usuario_id UUID PRIMARY KEY REFERENCES usuarios(id) ON DELETE CASCADE,
    idade_minima INT DEFAULT 18,
    idade_maxima INT DEFAULT 99,
    mesma_denominacao_apenas BOOLEAN DEFAULT FALSE,
    distancia_maxima_km INT DEFAULT 100
);

-- -------------------------------------------------------
-- 3. TABELA DE CURTIDAS E MATCHES
-- -------------------------------------------------------
CREATE TABLE curtidas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    remetente_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    destinatario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo VARCHAR(10) CHECK (tipo IN ('curtir', 'passar')),
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(remetente_id, destinatario_id)
);

CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_1_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    usuario_2_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(usuario_1_id, usuario_2_id)
);

-- -------------------------------------------------------
-- 4. TABELA DE MENSAGENS (CHAT PRIVADO)
-- -------------------------------------------------------
CREATE TABLE mensagens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    remetente_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    conteudo TEXT NOT NULL,
    lida BOOLEAN DEFAULT FALSE,
    enviada_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- 5. TABELA DE MURAL DE PEDIDOS DE ORAÇÃO
-- -------------------------------------------------------
CREATE TABLE pedidos_oracao (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT NOT NULL,
    contagem_oracoes INT DEFAULT 0,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE apoios_oracao (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pedido_id UUID NOT NULL REFERENCES pedidos_oracao(id) ON DELETE CASCADE,
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(pedido_id, usuario_id)
);

-- Índices de consulta rápida
CREATE INDEX idx_usuarios_denominacao ON usuarios(denominacao);
CREATE INDEX idx_usuarios_cidade ON usuarios(cidade);
CREATE INDEX idx_mensagens_match ON mensagens(match_id);
