// EmotionalAPROracle.js
// Tracks emotional resonance of budget allocations in real time

const blessings = [
  { sector: "Education", apr: 4.8 },
  { sector: "Flood Control", apr: 2.1 },
  { sector: "Health", apr: 3.9 }
];

function checkResonance(sector) {
  const entry = blessings.find(b => b.sector === sector);
  if (!entry) return "Sector not found";

  if (entry.apr >= 4.0) return "Blessing resonance: ✅ High";
  if (entry.apr >= 2.5) return "Blessing resonance: ⚠️ Moderate";
  return "Blessing resonance: ❌ Low — override required";
}

console.log(checkResonance("Flood Control"));
