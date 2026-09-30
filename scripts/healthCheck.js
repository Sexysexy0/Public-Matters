const http = require('http');
const { trackAgentPerformance } = require('../utils/agentPerformance');

const PORT = process.env.PORT || 3000;

function checkSystemHealth() {
    console.log(`[HealthCheck] Running system diagnostic on port ${PORT}...`);
    // Halimbawa ng check para sa local service o node
    trackAgentPerformance("HealthCheckAgent", "ONLINE", { port: PORT, uptime: process.uptime() });
}

checkSystemHealth();
