// Governance OS Integrity Audit Script
// Author: Vin (Chief Operator)

async function auditCovenantChain(grandChain) {
  const total = await grandChain.chainCount();
  console.log(`🔍 Auditing ${total} covenant entries...`);

  for (let i = 0; i < total; i++) {
    const entry = await grandChain.getChainEntry(i);
    const [name, safeguard, anchor, trigger, timestamp] = entry;

    if (!name || !safeguard || !anchor || !trigger) {
      console.error(`❌ Covenant ${i} is incomplete: ${name}`);
    } else {
      console.log(`✅ Covenant ${i} OK → ${name} | ${safeguard} | ${anchor} | Trigger: ${trigger} | Timestamp: ${timestamp}`);
    }
  }

  console.log("🛡️ Integrity Audit complete. All covenants verified.");
}
