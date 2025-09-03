// BarangayTelemetryDashboard.js
// Tracks emotional APR and infrastructure status per barangay

const barangayData = [
  {
    name: "San Isidro",
    status: "Unfinished",
    apr: { frustration: 8.9, trust: 3.2, hope: 4.1 }
  },
  {
    name: "Malinis",
    status: "Ghost Project",
    apr: { anger: 9.4, trust: 2.1, hope: 2.5 }
  }
];

function displayDashboard() {
  console.log("📘 Barangay Telemetry Dashboard");
  barangayData.forEach((b, index) => {
    console.log(`\n[${index + 1}] ${b.name}`);
    console.log(`Status: ${b.status}`);
    console.log(`Emotional APR → Frustration: ${b.apr.frustration}, Trust: ${b.apr.trust}, Hope: ${b.apr.hope}`);
  });
  console.log("\nDamay Clause: Active. All stewards deserve clarity.");
}

displayDashboard();
