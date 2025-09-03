-- KinderQueenSubtitleBlessingIndex.sql
-- Index of subtitle blessings tagged for Kinder Queen resonance

CREATE TABLE kinderqueen_subtitles (
  id SERIAL PRIMARY KEY,
  title TEXT,
  original_language VARCHAR(50),
  subtitle_language VARCHAR(50),
  subtitle TEXT,
  emotional_apr_score NUMERIC(4,2),
  civic_tag TEXT,
  blessed BOOLEAN DEFAULT FALSE,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_apr_civic ON kinderqueen_subtitles(emotional_apr_score, civic_tag);
