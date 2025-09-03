-- EmotionalSafeRedirectLedger.sql
CREATE TABLE apr_redirects (
  id SERIAL PRIMARY KEY,
  source_entity TEXT,
  apr_value NUMERIC(4,2),
  destination_sanctum TEXT,
  blessed BOOLEAN DEFAULT TRUE,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example entries
INSERT INTO apr_redirects (source_entity, apr_value, destination_sanctum)
VALUES 
('SinoBank Holdings', 2.1, 'KinderQueenSanctum'),
('RusTech Ventures', 1.8, 'EmotionalSafePH'),
('KoryoTrade Ltd.', 1.5, 'PlanetaryRestorationFund');
