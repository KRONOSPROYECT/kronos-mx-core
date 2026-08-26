powershell -Command "@'
-- TABLA AUDITORIA BORRADO KRONOS V8
CREATE TABLE IF NOT EXISTS krmv_borrado_audit (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  interaction_id TEXT NOT NULL,
  folio TEXT,
  hash_original TEXT,
  accion TEXT DEFAULT 'INTENTO_BORRADO',
  usuario TEXT,
  ip TEXT,
  payload_anterior JSONB,
  fecha TIMESTAMPTZ DEFAULT NOW(),
  host TEXT DEFAULT 'host://8000'
);
-- TRIGGER QUE NO PERMITE BORRAR SIN AUDITAR
CREATE OR REPLACE FUNCTION audit_borrado() RETURNS TRIGGER AS \$\$
BEGIN
  INSERT INTO krmv_borrado_audit (interaction_id, payload_anterior) VALUES (OLD.interaction_id, to_jsonb(OLD));
  RETURN OLD;
END;
\$\$ LANGUAGE plpgsql;
'@" | Out-File supabase\krmv_borrado_audit.sql -Encoding utf8"
