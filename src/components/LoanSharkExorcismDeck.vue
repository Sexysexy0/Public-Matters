<template>
  <div class="exorcism-deck">
    <h1>🛡️ Loan Shark Exorcism Deck</h1>
    <p>Reported entities, emotional damage logs, and civic actions</p>
    <ul>
      <li v-for="shark in sharks" :key="shark.address">
        <strong>{{ shark.name }}</strong> — {{ shark.location }}<br/>
        Interest: {{ shark.interestRate }}%<br/>
        Emotional Damage: {{ shark.emotionalDamageReport }}<br/>
        Status: {{ shark.isBlacklisted ? 'Blacklisted' : 'Pending' }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'LoanSharkExorcismDeck',
  data() {
    return {
      sharks: [
        {
          address: '0xDead...',
          name: 'OA Lending Co.',
          location: 'Malolos',
          interestRate: 45,
          emotionalDamageReport: 'Threatened family, manipulated terms',
          isBlacklisted: true
        }
      ]
    };
  }
};
</script>

<style scoped>
.exorcism-deck { padding: 2rem; background: #fff0f0; border-radius: 8px; }
ul { list-style: none; padding: 0; }
li { margin-bottom: 1rem; }
</style>
