-- BlessingLedgerSchema.sql
-- Ritual-grade schema for tracking DBM allocations, emotional APR, and barangay blessings

CREATE TABLE blessing_ledger (
  id SERIAL PRIMARY KEY,
  sector VARCHAR(100),
  region VARCHAR(100),
  amount NUMERIC(12,2),
  emotional_apr_score NUMERIC(4,2),
  damay_clause BOOLEAN DEFAULT TRUE,
  blessing_status VARCHAR(50),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sector_region ON blessing_ledger(sector, region);
