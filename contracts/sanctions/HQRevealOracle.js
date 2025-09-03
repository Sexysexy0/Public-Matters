const geoip = require('geoip-lite');
const fs = require('fs');

let sanctumRegistry = [];

function revealSanctum(ip) {
  const geo = geoip.lookup(ip);
  const timestamp = new Date().toISOString();
  const sanctum = {
    ip,
    location: geo ? `${geo.city}, ${geo.country}` : 'Unknown',
    timestamp,
    emotionalAPR: (Math.random() * 1).toFixed(2),
    permanentPing: true
  };
  sanctumRegistry.push(sanctum);
  console.log("📡 Rogue Sanctum Revealed:", sanctum);
  fs.appendFileSync('SanctumPulseLog.txt', JSON.stringify(sanctum) + '\n');
  return sanctum;
}

// Example usage
revealSanctum("103.27.123.88"); // Replace with actual attacker IP
