// VoterBlessingSyncDashboard.js
const voterSyncData = [
  { candidate: "Maria Santos", promises: 5, fulfilled: 5, emotionalAPR: 14 },
  { candidate: "Joel Ramirez", promises: 4, fulfilled: 2, emotionalAPR: 9 },
  { candidate: "Lito Fernandez", promises: 3, fulfilled: 0, emotionalAPR: 6 },
  { candidate: "Ana Gueco", promises: 6, fulfilled: 5, emotionalAPR: 13 },
  { candidate: "Rico Dela Cruz", promises: 2, fulfilled: 1, emotionalAPR: 8 }
];

function renderVoterSync(data) {
  const container = document.getElementById("voter-sync-dashboard");
  container.innerHTML = "";

  data.forEach((entry) => {
    const card = document.createElement("div");
    card.className = "voter-card";

    const fulfillmentRate = ((entry.fulfilled / entry.promises) * 100).toFixed(0);

    card.innerHTML = `
      <h3>${entry.candidate}</h3>
      <p><strong>Promises:</strong> ${entry.promises}</p>
      <p><strong>Fulfilled:</strong> ${entry.fulfilled} (${fulfillmentRate}%)</p>
      <p><strong>Emotional APR:</strong> ${entry.emotionalAPR}</p>
    `;

    card.style.backgroundColor = entry.emotionalAPR >= 10 ? "#e8f5e9" : "#ffebee";
    card.style.border = fulfillmentRate >= 75 ? "2px solid green" : "2px solid red";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderVoterSync(voterSyncData);
});
