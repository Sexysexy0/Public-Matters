// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Script, console} from "forge-std/Script.sol";
import {GlobalAssetRegistry} from "../src/GlobalAssetRegistry.sol";
import {OperatorPrivilegesV2} from "../src/OperatorPrivilegesV2.sol";
import {TrustIndex} from "../src/TrustIndex.sol";
import {TrustIntegrator} from "../src/TrustIntegrator.sol";
import {CoalitionBuilder} from "../src/CoalitionBuilder.sol";
import {OperatorConsciousnessLedger} from "../src/OperatorConsciousnessLedger.sol";
import {CabinetDAO} from "../src/CabinetDAO.sol";
import {FarmerCompensationVault} from "../src/FarmerCompensationVault.sol";
import {NuclearConflictRegistry} from "../src/NuclearConflictRegistry.sol";
import {NuclearDecisionGates} from "../src/NuclearDecisionGates.sol";
import {AIAgentSandbox} from "../src/AIAgentSandbox.sol";

contract DeployMasterArchitecture is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("=== INITIATING MASTER CODEBASE DEPLOYMENT ===");

        // 1. Core Security & Privilege Architecture (V2 Upgraded Engine)
        OperatorPrivilegesV2 privileges = new OperatorPrivilegesV2();
        console.log("OperatorPrivilegesV2 successfully deployed at:", address(privileges));

        // 2. Base Registries & Consciousness Sweeps
        GlobalAssetRegistry registry = new GlobalAssetRegistry();
        console.log("GlobalAssetRegistry deployed at:", address(registry));

        OperatorConsciousnessLedger ledger = new OperatorConsciousnessLedger(address(privileges));
        console.log("OperatorConsciousnessLedger deployed at:", address(ledger));

        // 3. Trust Infrastructure & Alliances
        TrustIndex trustIndex = new TrustIndex(address(privileges));
        console.log("TrustIndex deployed at:", address(trustIndex));

        TrustIntegrator trustIntegrator = new TrustIntegrator(address(trustIndex));
        console.log("TrustIntegrator deployed at:", address(trustIntegrator));

        CoalitionBuilder coalitionBuilder = new CoalitionBuilder(address(privileges));
        console.log("CoalitionBuilder deployed at:", address(coalitionBuilder));

        // 4. Extended Public Utilities & Administration Vaults
        CabinetDAO cabinet = new CabinetDAO(address(privileges));
        console.log("CabinetDAO deployed at:", address(cabinet));

        address mockNexusID = address(0x9999999999999999999999999999999999999999);
        FarmerCompensationVault compensationVault = new FarmerCompensationVault(address(privileges), mockNexusID);
        console.log("FarmerCompensationVault deployed at:", address(compensationVault));

        // 5. Frontier AI Safety & Pre-Production Isolation Sandbox
        AIAgentSandbox aiSandbox = new AIAgentSandbox(address(privileges));
        console.log("AIAgentSandbox deployed at:", address(aiSandbox));

        // 6. Nuclear Compliance Layers & Structural Gateway Matrix
        NuclearConflictRegistry conflictRegistry = new NuclearConflictRegistry();
        console.log("NuclearConflictRegistry deployed at:", address(conflictRegistry));

        // Mock evidence tracker address passed to constructor block
        address mockEvidenceTracker = address(0x8888888888888888888888888888888888888888);
        NuclearDecisionGates decisionGates = new NuclearDecisionGates(mockEvidenceTracker, address(conflictRegistry));
        console.log("NuclearDecisionGates deployed at:", address(decisionGates));

        // 7. Unified System Operational Whitelisting Loop
        privileges.addOperator(address(trustIntegrator));
        privileges.addOperator(address(ledger));
        privileges.addOperator(address(cabinet));
        privileges.addOperator(address(compensationVault));
        privileges.addOperator(address(aiSandbox));
        
        console.log("====================================================");
        console.log("System Architecture Upgrade Complete. Operations Secure.");

        vm.stopBroadcast();
    }
}
