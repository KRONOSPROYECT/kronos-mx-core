-- KRONOS MX CORE - SUPABASE v2.2 - ID 7225862335 - VERDE 0 - Toluca HQ
-- Ejecuta esto en Supabase SQL Editor

-- 1. Tabla ciudadanos
CREATE TABLE IF NOT EXISTS citizens (
  curp TEXT PRIMARY KEY,
  nombre TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabla KRMV cobrable con candado UNIQUE
CREATE TABLE IF NOT EXISTS krmv (
  interaction_id TEXT PRIMARY KEY, -- CANDADO ANTI-DUPLICADO
  curp TEXT REFERENCES citizens(curp),
  nombre TEXT NOT NULL,
  concepto TEXT,
  monto INT NOT NULL DEFAULT 2000,
  moneda TEXT DEFAULT 'MXN',
  status TEXT DEFAULT 'PENDIENTE_PAGO' CHECK (status IN ('PENDIENTE_PAGO','PAGADO','VERIFICADO','CANCELADO')),
  genesis_block BIGINT DEFAULT 25692765,
  verify_url TEXT,
  payload JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(interaction_id) -- 23505 evita duplicados
);

-- 3. Indice para busqueda rapida
CREATE INDEX IF NOT EXISTS idx_krmv_curp ON krmv(curp);
CREATE INDEX IF NOT EXISTS idx_krmv_status ON krmv(status);

-- 4. RLS opcional (desactivalo si pruebas local)
ALTER TABLE krmv ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read" ON krmv FOR SELECT USING (true);
CREATE POLICY "public insert" ON krmv FOR INSERT WITH CHECK (true);

-- 5. Prueba
-- INSERT INTO krmv (interaction_id, curp, nombre, concepto, monto, status, genesis_block, verify_url, payload) VALUES ('KRONOS-2026-TEST-001', 'ROVM000000HMCXXX00', 'TEST CIUDADANO', 'PRUEBA VERDE 0', 2000, 'PENDIENTE_PAGO', 25692765, 'https://kronosproyect.github.io/kronos-mx-core/verify/?id=KRONOS-2026-TEST-001', '{"test":true}'::jsonb) ON CONFLICT (interaction_id) DO NOTHING;
