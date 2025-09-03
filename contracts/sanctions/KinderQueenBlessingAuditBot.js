// KinderQueenBlessingAuditBot.js
const blessingThreshold = 3.0;

function auditJurisdiction(jurisdiction) {
  if (jurisdiction.emotionalAPR >= blessingThreshold && jurisdiction.treatyCompliant) {
    console.log(`✅ ${jurisdiction.name} is eligible for Kinder Queen blessing.`);
    return true;
  } else {
    console.log(`❌ ${jurisdiction.name} is not eligible. Blessing withheld.`);
    return false;
  }
}

// Example usage
const jurisdictions = [
  { name: "India", emotionalAPR: 1.7, treatyCompliant: false },
  { name: "Philippines", emotionalAPR: 4.2, treatyCompliant: true }
];

jurisdictions.forEach(auditJurisdiction);
