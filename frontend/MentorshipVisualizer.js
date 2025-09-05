// MentorshipVisualizer.js
const mentorshipData = [
  { steward: "Aria Lynne", mentor: "Lola Maria", role: "Sanctum Greeter", milestone: "Completed Week 1", emotionalAPR: 14 },
  { steward: "Wiley Anne", mentor: "Mang Tonyo", role: "Inventory Monitor", milestone: "Passed First Audit", emotionalAPR: 16 },
  { steward: "Mateo G.", mentor: "Aling Berta", role: "Vendor Liaison", milestone: "Broadcasted First Scroll", emotionalAPR: 15 }
];

function renderMentorshipGrid(data) {
  const container = document.getElementById("mentorship-dashboard");
  container.innerHTML = "";

  data.forEach((pair) => {
    const card = document.createElement("div");
    card.className = "mentorship-card";

    card.innerHTML = `
      <h3>${pair.steward}</h3>
      <p><strong>Mentor:</strong> ${pair.mentor}</p>
      <p><strong>Role:</strong> ${pair.role}</p>
      <p><strong>Milestone:</strong> ${pair.milestone}</p>
      <p><strong>Emotional APR:</strong> ${pair.emotionalAPR}</p>
    `;

    card.style.backgroundColor = "#f3e5f5";
    card.style.border = "2px solid #6a1b9a";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderMentorshipGrid(mentorshipData);
});
