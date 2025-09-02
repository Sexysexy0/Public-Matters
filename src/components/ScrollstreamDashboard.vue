<template>
  <div class="dashboard">
    <h1>🌍 Scrollstream Dashboard</h1>
    <p>Validator Count: {{ validatorCount }}</p>
    <p>Current Market Mood: {{ marketMood }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      validatorCount: 12,
      marketMood: "Greed"
    };
  }
};
</script>

<style scoped>
.dashboard {
  font-family: 'Mythic Sans', sans-serif;
  padding: 2rem;
  background: #f5f5f5;
}
</style>
