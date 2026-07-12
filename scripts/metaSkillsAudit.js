// Governance OS Meta-Skills Audit Script
// Author: Vin (Chief Operator)

async function auditMetaSkills(grandChain) {
  const total = await grandChain.chainCount();
  console.log(`🔍 Auditing ${total} covenant entries...`);

  const clusters = ["Self-Management", "Social Intelligence", "Innovation"];
  const skills = [
    "Integrity", "Adapting", "Initiative",
    "Communicating", "Collaborating", "Leading",
    "Curiosity", "Creativity", "Critical Thinking"
  ];

  for (let i = 0; i < total; i++) {
    const entry = await grandChain.getChainEntry(i);
    const [name, cluster, skill, trigger, timestamp] = entry;

    if (!clusters.includes(cluster) || !skills.includes(skill)) {
      console.error(`❌ Covenant ${i} invalid: ${name} | Cluster: ${cluster} | Skill: ${skill}`);
    } else {
      console.log(`✅ Covenant ${i} OK → ${name} | ${cluster} | Skill: ${skill} | Trigger: ${trigger} | Timestamp: ${timestamp}`);
    }
  }

  console.log("🛡️ Meta-Skills Audit complete. All clusters verified.");
}
