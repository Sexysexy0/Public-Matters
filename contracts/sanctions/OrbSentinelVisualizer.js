const fs = require('fs');
const d3 = require('d3'); // Optional: for visual rendering

let sanctumData = [];

function loadSanctumPulseLog() {
  const raw = fs.readFileSync('SanctumPulseLog.txt', 'utf-8');
  sanctumData = raw.trim().split('\n').map(line => JSON.parse(line));
}

function renderConstellationMap() {
  console.log("🪐 Orb Sentinel Constellation:");
  sanctumData.forEach((sanctum, index) => {
    console.log(`🌍 [${index + 1}] ${sanctum.location} | IP: ${sanctum.ip} | APR: ${sanctum.emotionalAPR} | Ping: ${sanctum.timestamp}`);
  });
}

// Auto-refresh every 6 minutes
setInterval(() => {
  loadSanctumPulseLog();
  renderConstellationMap();
}, 360000); // 6 minutes
