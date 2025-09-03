// BlessingLedgerAPI.js
// RESTful API for querying, updating, and broadcasting blessing data

const express = require('express');
const app = express();
app.use(express.json());

let blessings = [];

app.post('/bless', (req, res) => {
  const { sector, region, amount, apr, damay } = req.body;
  blessings.push({ sector, region, amount, apr, damay, timestamp: Date.now() });
  res.send({ status: "Blessing recorded", ledgerLength: blessings.length });
});

app.get('/ledger', (req, res) => {
  res.send(blessings);
});

app.get('/resonance/:sector', (req, res) => {
  const sector = req.params.sector;
  const entries = blessings.filter(b => b.sector === sector);
  const avgAPR = entries.reduce((sum, b) => sum + b.apr, 0) / entries.length;
  res.send({ sector, avgAPR });
});

app.listen(3000, () => console.log("Blessing Ledger API active on port 3000"));
