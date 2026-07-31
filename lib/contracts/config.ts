export interface ControlNode {
  code: string;
  domain: string;
  address: string;
  description: string;
}

export const CONTROL_TOWER_NODES: ControlNode[] = [
  {
    code: "CT-EHR-VAULT",
    domain: "Sovereign Encrypted EHR Vault",
    address: "0xD5DcE94be789C894aC8b5Cc78224b1D60A04b29e",
    description: "Encrypted IPFS health record registry with immutable access audit trails."
  },
  {
    code: "CT-EHR-CONSENT",
    domain: "Patient Consent & Delegation Engine",
    address: "0x1E442745693806223632d14682E71B1ffC2A986a",
    description: "Time-bound revocable doctor access delegation and appointment state engine."
  },
  {
    code: "CT-EQM",
    domain: "Equanimity Unbiased Execution Gateway",
    address: "0x4D4C6eBA676A3944dcAd0bc1252C1473CB3f4CD5",
    description: "Zero-bias cryptographic state engine eliminating metadata discrimination."
  },
  {
    code: "CT-SBOM",
    domain: "Hardware SBOM & Open-Source Attribution Registry",
    address: "0x8865ca059762e70be4a6e54c0a750cce458503336ee595d79fa20281ccfb982c",
    description: "On-chain open-source legal notice & SBOM enforcement for embedded hardware."
  }
];
