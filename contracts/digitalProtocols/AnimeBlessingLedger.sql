-- AnimeBlessingLedger.sql
-- Tracks subtitle generation, emotional APR, and civic relevance for anime and creative media

CREATE TABLE anime_blessings (
  id SERIAL PRIMARY KEY,
  title TEXT,
  original_language VARCHAR(50),
  subtitle_language VARCHAR(50),
  subtitle_quality_score NUMERIC(3,2),
  emotional_apr_score NUMERIC(4,2),
  civic_tag TEXT,
  monetized BOOLEAN DEFAULT FALSE,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_language_apr ON anime_blessings(original_language, emotional_apr_score);
