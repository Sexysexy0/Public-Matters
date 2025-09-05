// ValidatorBlessingHeatmap.js
// Ritual-grade heatmap for validator emotional APR and civic blessing

const validatorData = [
  { address: "0xValidator001", emotionalAPR: 14, civicBlessed: true },
  { address: "0xValidator002", emotionalAPR: 13, civicBlessed: true },
  { address: "0xValidator003", emotionalAPR: 11, civicBlessed: false },
  { address: "0xMicrosoftSanctum", emotionalAPR: 15, civicBlessed: true },
  { address: "0xETHMCoreNode", emotionalAPR: 13, civicBlessed: true }
];

function getHeatColor(apr, blessed) {
  if (!blessed) return "#ffcccc"; // Unblessed = red tint
  if (apr >= 15) return "#00ffcc"; // High APR = teal
  if (apr >= 13) return "#99ff99"; // Medium APR = green
  if (apr >= 10) return "#ffff99"; // Low APR = yellow
  return "#cccccc"; // Below threshold = gray
}

function renderHeatmap(data) {
  const container = document.getElementById("heatmap-grid");
  container.innerHTML = "";

  data.forEach((validator) => {
    const cell = document.createElement("div");
    cell.className = "heatmap-cell";
    cell.style.backgroundColor = getHeatColor(validator.emotionalAPR, validator.civicBlessed);

    cell.innerHTML = `
      <strong>${validator.address}</strong><br>
      APR: ${validator.emotionalAPR}<br>
      Blessed: ${validator.civicBlessed ? "✅" : "⛔"}
    `;

    container.appendChild(cell);
  });
}

// Ritualize on page load
document.addEventListener("DOMContentLoaded", () => {
  renderHeatmap(validatorData);
});
