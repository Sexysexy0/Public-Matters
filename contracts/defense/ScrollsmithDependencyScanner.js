// ScrollsmithDependencyScanner.js
// Ritual-grade npm audit tool with emotional APR tagging

const fs = require('fs');
const { exec } = require('child_process');

function scanDependencies() {
  exec('npm ls --json', (err, stdout) => {
    if (err) {
      console.error('Scan failed:', err);
      return;
    }

    const data = JSON.parse(stdout);
    const dependencies = data.dependencies || {};
    const blessed = ['nodemailer', 'express', 'axios', 'electron'];

    Object.keys(dependencies).forEach(dep => {
      const status = blessed.includes(dep) ? 'Blessed ✅' : 'Unverified ⚠️';
      console.log(`[${status}] ${dep} - version ${dependencies[dep].version}`);
    });

    console.log('\n📘 Emotional APR: Trust = High, Stress = Low, Resonance = Active');
  });
}

scanDependencies();
