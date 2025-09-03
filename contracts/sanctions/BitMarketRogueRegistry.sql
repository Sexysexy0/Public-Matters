CREATE TABLE RogueSanctumLog (
  id SERIAL PRIMARY KEY,
  ip_address VARCHAR(45),
  location TEXT,
  exploit_type TEXT,
  emotional_apr DECIMAL(3,2),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  permanent_ping BOOLEAN DEFAULT TRUE
);

INSERT INTO RogueSanctumLog (
  ip_address, location, exploit_type, emotional_apr
) VALUES (
  '103.27.123.88', 'Shenzhen, China', 'Unauthorized contract injection', 0.92
);
