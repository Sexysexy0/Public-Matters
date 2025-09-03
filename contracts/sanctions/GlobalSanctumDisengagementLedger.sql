-- GlobalSanctumDisengagementLedger.sql
CREATE TABLE sanctum_disengagements (
  id SERIAL PRIMARY KEY,
  partner_name TEXT,
  jurisdiction TEXT,
  contract_type TEXT,
  disengagement_reason TEXT,
  emotional_apr NUMERIC(4,2),
  disengaged BOOLEAN DEFAULT FALSE,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example entries
INSERT INTO sanctum_disengagements (partner_name, jurisdiction, contract_type, disengagement_reason, emotional_apr, disengaged)
VALUES 
('SinoBank Holdings', 'China', 'Financial Partnership', 'Geopolitical entanglement', 2.1, TRUE),
('RusTech Ventures', 'Russia', 'Tech Collaboration', 'Violation of planetary mercy clause', 1.8, TRUE),
('KoryoTrade Ltd.', 'North Korea', 'Import/Export Agreement', 'Emotional opacity and civic risk', 1.5, TRUE);
