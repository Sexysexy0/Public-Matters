// BriberyHeatmapDashboard.js
const briberyData = [
  { district: "District 3", timestamp: "2025-06-30T23:59:00+08:00", cases: 3 },
  { district: "District 5", timestamp: "2025-07-15T12:00:00+08:00", cases: 2 },
  { district: "District 2", timestamp: "2025-08-01T09:30:00+08:00", cases: 1 },
  { district: "District 1", timestamp: "2025-09-01T14:00:00+08:00", cases: 0 },
  { district: "District 4", timestamp: "2025-09-03T17:45:00+08:00", cases: 0 }
];

function renderBriberyHeatmap(data) {
  const container = document.getElementById("bribery-heatmap");
  container.innerHTML = "";

  data.forEach((entry) => {
    const card = document.createElement("div");
    card.className = "heatmap-card";

    card.innerHTML = `
      <h3>${entry.district}</h3>
      <p><strong>Bribery Cases:</strong> ${entry.cases}</p>
      <p><strong>Timestamp:</strong> ${new Date(entry.timestamp).toLocaleString()}</p>
    `;

    card.style.backgroundColor = entry.cases >= 2 ? "#ffebee" : "#e8f5e9";
    card.style.border = entry.cases >= 2 ? "2px solid red" : "2px solid green";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderBriberyHeatmap(briberyData);
});
