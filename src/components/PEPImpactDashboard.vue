<template>
  <div class="pep-dashboard">
    <h1>🌺 PEP Impact Dashboard</h1>
    <table>
      <thead>
        <tr>
          <th>Region</th>
          <th>Festival</th>
          <th>Emotional APR</th>
          <th>Visitor Count</th>
          <th>Resonance Score</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="event in pepEvents" :key="event.id">
          <td>{{ event.region }}</td>
          <td>{{ event.festival }}</td>
          <td>{{ event.apr }}</td>
          <td>{{ event.visitors }}</td>
          <td>{{ event.resonance }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: "PEPImpactDashboard",
  data() {
    return {
      pepEvents: [
        {
          id: 1,
          region: "Ilocos",
          festival: "Empanada Fiesta",
          apr: "🌞 High",
          visitors: 12000,
          resonance: 92,
        },
        {
          id: 2,
          region: "Bicol",
          festival: "Pili Festival",
          apr: "🌿 Moderate",
          visitors: 8500,
          resonance: 78,
        },
        {
          id: 3,
          region: "Visayas",
          festival: "Sinulog",
          apr: "🔥 Surge",
          visitors: 30000,
          resonance: 98,
        },
      ],
    };
  },
};
</script>

<style scoped>
.pep-dashboard {
  font-family: "Segoe UI", sans-serif;
  padding: 2rem;
}
table {
  width: 100%;
  border-collapse: collapse;
}
th,
td {
  padding: 0.75rem;
  border: 1px solid #ccc;
  text-align: center;
}
</style>
