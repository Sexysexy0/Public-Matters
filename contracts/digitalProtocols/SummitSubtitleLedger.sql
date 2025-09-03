-- SummitSubtitleLedger.sql
-- Tracks subtitle generation, civic relevance, and emotional APR across global media

CREATE TABLE summit_subtitles (
  id SERIAL PRIMARY KEY,
  video_title TEXT,
  source_language VARCHAR(50),
  translated_text TEXT,
  civic_relevance_tag VARCHAR(100),
  emotional_apr_score NUMERIC(4,2),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_language_apr ON summit_subtitles(source_language, emotional_apr_score);
