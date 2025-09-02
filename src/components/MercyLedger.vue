<template>
  <div class="mercy-ledger">
    <h1>🧾 Mercy Ledger</h1>
    <p>Emotional APR, civic relief, and override status</p>
    <table>
      <thead>
        <tr>
          <th>Borrower</th>
          <th>Amount</th>
          <th>Emotional APR</th>
          <th>Override</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="loan in loans" :key="loan.id">
          <td>{{ loan.borrower }}</td>
          <td>{{ loan.amount }}</td>
          <td>{{ loan.emotionalAPR }}</td>
          <td>{{ loan.overrideTriggered ? '✅' : '❌' }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'MercyLedger',
  data() {
    return {
      loans: [
        { id: 1, borrower: '0xAbc...', amount: 5000, emotionalAPR: 12, overrideTriggered: false },
        { id: 2, borrower: '0xDef...', amount: 3000, emotionalAPR: 8, overrideTriggered: true }
      ]
    };
  }
};
</script>

<style scoped>
.mercy-ledger { padding: 2rem; background: #f9f9f9; border-radius: 8px; }
table { width: 100%; border-collapse: collapse; }
th, td { padding: 0.5rem; border: 1px solid #ccc; }
</style>
