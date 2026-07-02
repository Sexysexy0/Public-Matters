import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const GovernanceModule = buildModule("GovernanceModule", (m) => {
  const initialAdmin = m.getParameter(
    "initialAdmin",
    "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
  );

  // Deploy SecurityGovernance
  const securityGovernance = m.contract("SecurityGovernance", [initialAdmin]);

  // Deploy UnityTreaty
  const unityTreaty = m.contract("UnityTreaty", [initialAdmin]);

  // Deploy JusticeCodex
  const justiceCodex = m.contract("JusticeCodex", [initialAdmin]);

  return { securityGovernance, unityTreaty, justiceCodex };
});

export default GovernanceModule;
