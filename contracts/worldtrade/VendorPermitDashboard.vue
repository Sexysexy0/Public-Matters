<template>
  <div class="dashboard">
    <h1>📜 Vendor Permit Dashboard</h1>
    <form @submit.prevent="submitPermit">
      <label>Vendor Name:</label>
      <input v-model="vendorName" />

      <label>Permit Category:</label>
      <select v-model="category">
        <option>Eco Imports</option>
        <option>Luxury Exports</option>
        <option>Barangay Goods</option>
      </select>

      <label>Emotional APR:</label>
      <input type="number" v-model="empathy" placeholder="Empathy" />
      <input type="number" v-model="trust" placeholder="Trust" />
      <input type="number" v-model="clarity" placeholder="Clarity" />

      <button type="submit">Bless & Submit</button>
    </form>

    <div v-if="permitIssued">
      <h2>✅ Permit Issued</h2>
      <p>Vendor: {{ vendorName }}</p>
      <p>Category: {{ category }}</p>
      <p>Emotional APR: {{ empathy + trust + clarity }}</p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      vendorName: '',
      category: '',
      empathy: 0,
      trust: 0,
      clarity: 0,
      permitIssued: false
    };
  },
  methods: {
    submitPermit() {
      this.permitIssued = true;
      // Optional: trigger smart contract interaction here
    }
  }
};
</script>

<style scoped>
.dashboard {
  padding: 2rem;
  background: #f9f9f9;
  border-radius: 8px;
}
input, select {
  margin: 0.5rem 0;
  padding: 0.5rem;
  width: 100%;
}
button {
  background: #4CAF50;
  color: white;
  padding: 0.75rem;
  border: none;
  cursor: pointer;
}
</style>
