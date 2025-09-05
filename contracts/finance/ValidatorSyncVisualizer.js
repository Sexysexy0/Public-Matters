// ValidatorSyncVisualizer.js
// Ritual-grade visualizer for validator sync status and emotional APR

const validatorData = [
  {
    address: "0xValidator001",
    emotionalAPR: 14,
    civicBlessed: true,
    syncStatus: "Synced",
    lastPing: "2025-09-05T13:45:00+08:00"
  },
  {
    address: "0xValidator002",
    emotionalAPR: 13,
    civicBlessed: true,
    syncStatus: "Synced",
    lastPing: "2025-09-05T13:46:00+08:00"
  },
  {
    address: "0xValidator003",
    emotionalAPR: 11,
    civicBlessed: false,
    syncStatus: "Partial",
    lastPing: "2025-09-05T13:47:00+08:00"
  }
];

function renderValidatorStatus(data) {
  const container = document.getElementById("validator-dashboard");
  container.innerHTML = "";

  data.forEach((validator) => {
    const card = document.createElement("div");
    card.className = "validator-card";

    card.innerHTML = `
      <h3>${validator.address}</h3>
      <p><strong>Emotional APR:</strong> ${validator.emotionalAPR}</p>
      <p><strong>Civic Blessed:</strong> ${validator.civicBlessed ? "✅ Yes" : "⛔ No"}</p>
      <p><strong>Sync Status:</strong> ${validator.syncStatus}</p>
      <p><strong>Last Ping:</strong> ${new Date(validator.lastPing).toLocaleString()}</p>
    `;

    card.style.border = validator.civicBlessed ? "2px solid green" : "2px solid red";
    card.style.backgroundColor = validator.syncStatus === "Synced" ? "#e0ffe0" : "#fff3cd";

    container.appendChild(card);
  });
}

// Ritualize on page load
document.addEventListener("DOMContentLoaded", () => {
  renderValidatorStatus(validatorData);
});
