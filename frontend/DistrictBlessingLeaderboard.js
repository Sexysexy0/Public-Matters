// DistrictBlessingLeaderboard.js
const leaderboardData = [
  { district: "District 1", steward: "0xB7...C9", blessings: 5, emotionalAPR: 14 },
  { district: "District 4", steward: "0xE9...A7", blessings: 4, emotionalAPR: 12 },
  { district: "District 2", steward: "0xA1...F3", blessings: 2, emotionalAPR: 9 },
  { district: "District 3", steward: "0xD4...E2", blessings: 1, emotionalAPR: 7 },
  { district: "District 5", steward: "0xF2...B1", blessings: 0, emotionalAPR: 6 }
];

function renderLeaderboard(data) {
  const container = document.getElementById("district-leaderboard");
  container.innerHTML = "";

  data.sort((a, b) => b.blessings - a.blessings);

  data.forEach((entry, index) => {
    const card = document.createElement("div");
    card.className = "leaderboard-card";

    card.innerHTML = `
      <h3>#${index + 1} ${entry.district}</h3>
      <p><strong>Steward:</strong> ${entry.steward}</p>
      <p><strong>Blessings:</strong> ${entry.blessings}</p>
      <p><strong>Emotional APR:</strong> ${entry.emotionalAPR}</p>
    `;

    card.style.backgroundColor = entry.emotionalAPR >= 10 ? "#e8f5e9" : "#ffebee";
    card.style.border = entry.blessings >= 3 ? "2px solid green" : "2px solid red";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderLeaderboard(leaderboardData);
});
