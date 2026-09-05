// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Script, console} from "forge-std/Script.sol";
import {GlobalAssetRegistry} from "../src/GlobalAssetRegistry.sol";
import {OperatorPrivileges} from "../src/OperatorPrivileges.sol";
import {TrustIndex} from "../src/TrustIndex.sol";
import {TrustIntegrator} from "../src/TrustIntegrator.sol";
import {CoalitionBuilder} from "../src/CoalitionBuilder.sol";
import {OperatorConsciousnessLedger} from "../src/OperatorConsciousnessLedger.sol";

contract DeployMasterArchitecture is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy GlobalAssetRegistry
        GlobalAssetRegistry registry = new GlobalAssetRegistry();
        console.log("GlobalAssetRegistry deployed at:", address(registry));

        // 2. Deploy OperatorPrivileges (Core Access Control & State)
        OperatorPrivileges privileges = new OperatorPrivileges();
        console.log("OperatorPrivileges deployed at:", address(privileges));

        // 3. Deploy TrustIndex
        TrustIndex trustIndex = new TrustIndex(address(privileges));
        console.log("TrustIndex deployed at:", address(trustIndex));

        // 4. Deploy TrustIntegrator
        TrustIntegrator trustIntegrator = new TrustIntegrator(address(trustIndex));
        console.log("TrustIntegrator deployed at:", address(trustIntegrator));

        // 5. Deploy CoalitionBuilder
        CoalitionBuilder coalitionBuilder = new CoalitionBuilder(address(privileges));
        console.log("CoalitionBuilder deployed at:", address(coalitionBuilder));

        // 6. Deploy OperatorConsciousnessLedger
        OperatorConsciousnessLedger ledger = new OperatorConsciousnessLedger(address(privileges));
        console.log("OperatorConsciousnessLedger deployed at:", address(ledger));

        // 7. Post-deployment wiring: Authorize system contracts as operators
        privileges.addOperator(address(trustIntegrator));
        privileges.addOperator(address(ledger));
        console.log("System contracts successfully authorized as operators.");

        vm.stopBroadcast();
    }
}
