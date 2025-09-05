// PlacementVisualizer.js
const stewardData = [
  { name: "Lola Maria", age: 67, role: "Sanctum Greeter", emotionalAPR: 16, civicBlessed: true },
  { name: "Mang Tonyo", age: 62, role: "Inventory Monitor", emotionalAPR: 15, civicBlessed: true },
  { name: "Aling Berta", age: 70, role: "Mentorship Advisor", emotionalAPR: 17, civicBlessed: true }
];

function renderPlacementGrid(data) {
  const container = document.getElementById("placement-dashboard");
  container.innerHTML = "";

  data.forEach((steward) => {
    const card = document.createElement("div");
    card.className = "placement-card";

    card.innerHTML = `
      <h3>${steward.name}</h3>
      <p><strong>Age:</strong> ${steward.age}</p>
      <p><strong>Role:</strong> ${steward.role}</p>
      <p><strong>Emotional APR:</strong> ${steward.emotionalAPR}</p>
      <p><strong>Civic Blessed:</strong> ${steward.civicBlessed ? "✅ Yes" : "⛔ No"}</p>
    `;

    card.style.backgroundColor = steward.age >= 60 ? "#e0f7fa" : "#f0f0f0";
    card.style.border = steward.civicBlessed ? "2px solid green" : "2px solid red";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderPlacementGrid(stewardData);
});
