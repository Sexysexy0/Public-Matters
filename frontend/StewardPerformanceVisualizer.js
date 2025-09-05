// StewardPerformanceVisualizer.js
const stewardData = [
  { steward: "0xA1...F3", strikeLevel: 2, emotionalAPR: 9, blessingStatus: "Pending" },
  { steward: "0xB7...C9", strikeLevel: 0, emotionalAPR: 14, blessingStatus: "Blessed" },
  { steward: "0xD4...E2", strikeLevel: 3, emotionalAPR: 7, blessingStatus: "Under Review" }
];

function renderStewardDashboard(data) {
  const container = document.getElementById("steward-dashboard");
  container.innerHTML = "";

  data.forEach((entry) => {
    const card = document.createElement("div");
    card.className = "steward-card";

    card.innerHTML = `
      <h3>Steward: ${entry.steward}</h3>
      <p><strong>Strike Level:</strong> ${entry.strikeLevel}</p>
      <p><strong>Emotional APR:</strong> ${entry.emotionalAPR}</p>
      <p><strong>Blessing Status:</strong> ${entry.blessingStatus}</p>
    `;

    card.style.backgroundColor = entry.emotionalAPR >= 10 ? "#e8f5e9" : "#ffebee";
    card.style.border = entry.strikeLevel >= 3 ? "2px solid red" : "2px solid green";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderStewardDashboard(stewardData);
});
