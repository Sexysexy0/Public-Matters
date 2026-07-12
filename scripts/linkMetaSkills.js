// Governance OS GrandChain Linkage Update
// Author: Vin (Chief Operator)

async function linkMetaSkills(grandChain, metaSkillsAddress) {
  console.log("🔗 Linking MetaSkillsCovenant to GrandChain...");

  const clusters = [
    { cluster: "Self-Management", skills: ["Integrity", "Adapting", "Initiative"] },
    { cluster: "Social Intelligence", skills: ["Communicating", "Collaborating", "Leading"] },
    { cluster: "Innovation", skills: ["Curiosity", "Creativity", "Critical Thinking"] }
  ];

  for (const c of clusters) {
    for (const s of c.skills) {
      await grandChain.linkCovenant("MetaSkillsCovenant", c.cluster, s, "Governance trigger");
      console.log(`✅ Linked ${s} under ${c.cluster}`);
    }
  }

  console.log("🛡️ MetaSkillsCovenant fully registered in GrandChain.");
}
