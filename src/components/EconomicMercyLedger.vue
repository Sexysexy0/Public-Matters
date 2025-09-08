<template>
  <div class="mercy-ledger">
    <h1>📉 Economic Mercy Ledger</h1>
    <table>
      <thead>
        <tr>
          <th>Record ID</th>
          <th>Debt</th>
          <th>GDP</th>
          <th>Ratio (%)</th>
          <th>Pardon</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="r in records" :key="r.id">
          <td>{{ r.id }}</td>
          <td>{{ r.debt }}</td>
          <td>{{ r.gdp }}</td>
          <td>{{ ((r.debt / r.gdp) * 100).toFixed(2) }}</td>
          <td>{{ r.overrideTriggered ? "✅" : "❌" }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: "EconomicMercyLedger",
  data() {
    return {
      records: [
        { id: 0, debt: 1000, gdp: 1500, overrideTriggered: false },
        { id: 1, debt: 1200, gdp: 1600, overrideTriggered: true },
      ],
    };
  },
};
</script>

<style scoped>
.mercy-ledger {
  padding: 2rem;
  background: #eef;
  border-radius: 8px;
}
table {
  width: 100%;
  border-collapse: collapse;
}
th,
td {
  padding: 0.5rem;
  border: 1px solid #ccc;
}
</style>
