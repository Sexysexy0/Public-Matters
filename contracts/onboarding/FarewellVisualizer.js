// FarewellVisualizer.js
const farewellData = [
  { name: "Lola Maria", years: 3, voluntary: false, payout: 300000, emotionalAPR: 17, farewellNote: "Salamat sa lahat ng taon ng serbisyo." },
  { name: "Mang Tonyo", years: 1, voluntary: true, payout: 50000, emotionalAPR: 15, farewellNote: "Magpapahinga na po ako, pero salamat sa pagmamahal." }
];

function renderFarewellGrid(data) {
  const container = document.getElementById("farewell-dashboard");
  container.innerHTML = "";

  data.forEach((steward) => {
    const card = document.createElement("div");
    card.className = "farewell-card";

    card.innerHTML = `
      <h3>${steward.name}</h3>
      <p><strong>Tenure:</strong> ${steward.years} year(s)</p>
      <p><strong>Exit Type:</strong> ${steward.voluntary ? "Voluntary" : "Involuntary"}</p>
      <p><strong>Payout:</strong> ₱${steward.payout.toLocaleString()}</p>
      <p><strong>Emotional APR:</strong> ${steward.emotionalAPR}</p>
      <p><em>"${steward.farewellNote}"</em></p>
    `;

    card.style.backgroundColor = steward.voluntary ? "#fff3e0" : "#e0f7fa";
    card.style.border = "2px solid #4caf50";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderFarewellGrid(farewellData);
});
