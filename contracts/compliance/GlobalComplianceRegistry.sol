// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./GlobalComplianceRegistry.sol";

contract InitCompliance {
    GlobalComplianceRegistry public registry;

    constructor(address registryAddress) {
        registry = GlobalComplianceRegistry(registryAddress);

        // Philippines (PH)
        registry.addOrUpdateJurisdiction(
            "PH",
            "Philippines",
            true,  // licensingRequired
            GlobalComplianceRegistry.KycTier.Enhanced,
            true,  // stablecoinAllowed
            true,  // cryptoDonationsAllowed
            GlobalComplianceRegistry.RiskLevel.Medium,
            "BSP-regulated VASP license required; AMLA compliance",
            true   // active
        );
        registry.setAssetRule("PH", GlobalComplianceRegistry.AssetClass.Native, true, "BTC/ETH permitted under VASP");
        registry.setAssetRule("PH", GlobalComplianceRegistry.AssetClass.Stablecoin, true, "Only BSP-approved stablecoins");

        // European Union (EU)
        registry.addOrUpdateJurisdiction(
            "EU",
            "European Union",
            true,
            GlobalComplianceRegistry.KycTier.Enhanced,
            true,
            true,
            GlobalComplianceRegistry.RiskLevel.Low,
            "MiCAR transitional regime until 2026; harmonized licensing",
            true
        );
        registry.setAssetRule("EU", GlobalComplianceRegistry.AssetClass.Native, true, "BTC/ETH permitted under MiCAR");
        registry.setAssetRule("EU", GlobalComplianceRegistry.AssetClass.Stablecoin, true, "Only regulated issuers (e.g., USDC, EURC)");

        // United States (US)
        registry.addOrUpdateJurisdiction(
            "US",
            "United States",
            true,
            GlobalComplianceRegistry.KycTier.Enhanced,
            true,
            true,
            GlobalComplianceRegistry.RiskLevel.Medium,
            "SEC/CFTC split; state-by-state MSB licensing",
            true
        );
        registry.setAssetRule("US", GlobalComplianceRegistry.AssetClass.Native, true, "BTC/ETH permitted with MSB license");
        registry.setAssetRule("US", GlobalComplianceRegistry.AssetClass.Stablecoin, true, "Stablecoins under NYDFS or equivalent");

        // Singapore (SG)
        registry.addOrUpdateJurisdiction(
            "SG",
            "Singapore",
            true,
            GlobalComplianceRegistry.KycTier.Enhanced,
            true,
            true,
            GlobalComplianceRegistry.RiskLevel.Low,
            "MAS Payment Services Act; clear stablecoin framework",
            true
        );
        registry.setAssetRule("SG", GlobalComplianceRegistry.AssetClass.Native, true, "BTC/ETH permitted under PSA");
        registry.setAssetRule("SG", GlobalComplianceRegistry.AssetClass.Stablecoin, true, "MAS-approved stablecoins only");
    }
}
