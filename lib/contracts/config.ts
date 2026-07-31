export interface ControlNode {
  code: string;
  domain: string;
  address: string;
  description: string;
}

export const CONTROL_TOWER_NODES: ControlNode[] = [
  {
    code: "CT-EQM",
    domain: "Equanimity Unbiased Execution Gateway",
    address: "0x4D4C6eBA676A3944dcAd0bc1252C1473CB3f4CD5",
    description: "Zero-bias cryptographic state engine eliminating metadata discrimination."
  },
  {
    code: "CT-GOV",
    domain: "Family Governance & Trust Registry",
    address: "0xE8E0e4F795A1A285395F6F8d5EA80adEf8c076F1",
    description: "Multi-jurisdictional trust agreements and family charter enforcement."
  },
  {
    code: "CT-TAX",
    domain: "Global Tax Dependency Engine",
    address: "0x8920C1a62939B2788eE750A8619a9B23122c6D12",
    description: "Automated cross-border tax obligation tracking and exposure mitigation."
  },
  {
    code: "CT-LEG",
    domain: "Entity & Holding Structure Vault",
    address: "0x71B9a4C829019bB3D1e5eD773950e18A6f788A21",
    description: "Corporate registry, power of attorney, and legal entity mapping."
  },
  {
    code: "CT-INV",
    domain: "Capital Allocation & Liquidity Control",
    address: "0x33A190cD901a1178aA2eE1B391097e163bB72F18",
    description: "Unified view of private equity, real estate, and liquid holdings."
  }
];
