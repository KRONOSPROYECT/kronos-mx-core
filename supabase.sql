-- Habilitación de extensiones criptográficas nativas de la infraestructura
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabla Maestra KRONOS MX CORE v2.2 - Notario Digital Global
CREATE TABLE evidencias_fotos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    folio VARCHAR(50) NOT NULL,
    foto_hash CHAR(64) NOT NULL,
    interaction_id CHAR(64) NOT NULL UNIQUE,
    titular VARCHAR(100) NOT NULL,
    caducidad DATE NOT NULL DEFAULT '2027-08-13',
    estado SMALLINT DEFAULT 0, -- 0: VERDE 0 = ACTIVO, 1: REVOCADO, 2: AUDITORÍA
    estado_txt VARCHAR(30) DEFAULT 'VERDE 0 = ACTIVO',
    timestamp_ms TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp(),
    ntp VARCHAR(100) DEFAULT 'pool.ntp.org + GPS Sub-millisecond Anchor',
    tx_eth CHAR(66) NOT NULL,
    bloque BIGINT NOT NULL,
    safe_creative VARCHAR(50) NOT NULL,
    
    -- Matrices de Cumplimiento Indexadas por Fase del Roadmap
    compliance_mx VARCHAR(150) DEFAULT 'NOM-151 Contratos de Membresía Privada + LFEA Art 89 + Código de Comercio Art 49 Constancia Digital',
    compliance_eu VARCHAR(150) DEFAULT 'eIDAS Art 25 Proveedor de Servicios de Confianza + ISO 27037 Preservación de Evidencia + GDPR Art 25 Privacy by Design',
    compliance_us VARCHAR(150) DEFAULT 'Federal Rules of Evidence FRE 902(13) Self-Authenticating Digital Evidence + UETA Compliance',
    
    -- Datos de Recaudación y Cumplimiento Financiero (No Captación Art 316 CP)
    clabe VARCHAR(18) DEFAULT '012180015512345678',
    concepto VARCHAR(50) NOT NULL,
    regimen VARCHAR(100) DEFAULT 'Sociedad Tecnológica Privada - NO CAPTACION Art 316 CP',
    fase_roadmap VARCHAR(30) DEFAULT 'Fase 1: México (2026-2027)',
    
    -- CANDADO DE INTEGRIDAD FORENSE B5: Bloquea intentos de clonación de evidencia
    CONSTRAINT unique_folio_hash UNIQUE (folio, foto_hash)
);

-- Índices optimizados para búsquedas sub-milisegundo en auditorías masivas
CREATE INDEX idx_kronos_hash ON evidencias_fotos(foto_hash);
CREATE INDEX idx_kronos_folio ON evidencias_fotos(folio);
