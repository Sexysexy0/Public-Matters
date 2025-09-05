// BlessingSurgeDashboard.js
const blessingSurgeData = [
  { steward: "0xA1...F3", blessings: 2, reroutes: 1, emotionalAPR: 9 },
  { steward: "0xB7...C9", blessings: 5, reroutes: 0, emotionalAPR: 14 },
  { steward: "0xD4...E2", blessings: 1, reroutes: 3, emotionalAPR: 7 },
  { steward: "0xE9...A7", blessings: 4, reroutes: 0, emotionalAPR: 12 },
  { steward: "0xF2...B1", blessings: 0, reroutes: 2, emotionalAPR: 6 }
];

function renderBlessingSurge(data) {
  const container = document.getElementById("blessing-surge-dashboard");
  container.innerHTML = "";

  data.forEach((entry) => {
    const card = document.createElement("div");
    card.className = "blessing-card";

    card.innerHTML = `
      <h3>Steward: ${entry.steward}</h3>
      <p><strong>Blessings:</strong> ${entry.blessings}</p>
      <p><strong>Reroutes:</strong> ${entry.reroutes}</p>
      <p><strong>Emotional APR:</strong> ${entry.emotionalAPR}</p>
    `;

    card.style.backgroundColor = entry.emotionalAPR >= 10 ? "#e8f5e9" : "#ffebee";
    card.style.border = entry.reroutes >= 2 ? "2px solid red" : "2px solid green";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderBlessingSurge(blessingSurgeData);
});
