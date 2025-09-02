<template>
  <div class="support-signal">
    <h1>📡 Support Signal Protocol</h1>
    <p>Visualizing unresolved support loops and ghosted tickets</p>

    <div v-if="alerts.length">
      <ul>
        <li v-for="alert in alerts" :key="alert.id">
          <strong>{{ alert.timestamp }}</strong> — {{ alert.message }}
          <span v-if="alert.ghosted">👻 Ghosted</span>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>All support signals are clear. Damay clause honored.</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SupportSignalProtocol',
  data() {
    return {
      alerts: [
        {
          id: 1,
          timestamp: '2025-09-01 12:45 UTC',
          message: 'Forecast breach alert ignored by support',
          ghosted: true
        },
        {
          id: 2,
          timestamp: '2025-09-01 13:10 UTC',
          message: 'Comment deleted from forum',
          ghosted: true
        }
      ]
    }
  }
}
</script>

<style scoped>
.support-signal {
  padding: 2rem;
  background-color: #f5f5f5;
  border-radius: 8px;
}
</style>
