// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../contracts/prediction/MarketParticipantRegistry.sol";
import "../contracts/prediction/KnowledgeOracle.sol";
import "../contracts/prediction/FairLiquidityPool.sol";
import "../contracts/prediction/MarketAuditLedger.sol";
import "../contracts/prediction/RegulatoryCompliance.sol";

contract DeployPrediction is Script {
    function run() external {
        vm.startBroadcast();

        MarketParticipantRegistry registry = new MarketParticipantRegistry();
        KnowledgeOracle oracle = new KnowledgeOracle();
        FairLiquidityPool pool = new FairLiquidityPool();
        MarketAuditLedger ledger = new MarketAuditLedger();
        RegulatoryCompliance compliance = new RegulatoryCompliance();

        console.log("MarketParticipantRegistry deployed at:", address(registry));
        console.log("KnowledgeOracle deployed at:", address(oracle));
        console.log("FairLiquidityPool deployed at:", address(pool));
        console.log("MarketAuditLedger deployed at:", address(ledger));
        console.log("RegulatoryCompliance deployed at:", address(compliance));

        vm.stopBroadcast();
    }
}
