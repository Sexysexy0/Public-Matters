// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AccountabilityArc.sol";
import "../src/EvidenceRegistry.sol";
import "../src/SkepticismProtocol.sol";
import "../src/TransparencyLedger.sol";
import "../src/VerificationCodex.sol";
import "../src/IntellectualDiversity.sol";
import "../src/MarketAccountability.sol";
import "../src/FundamentalEducation.sol";
import "../src/ResearchDecentralization.sol";

contract MasterDeployment is Script {
    function run() external {
        vm.startBroadcast();

        // Safeguards
        AccountabilityArc arc = new AccountabilityArc();
        EvidenceRegistry registry = new EvidenceRegistry();
        SkepticismProtocol protocol = new SkepticismProtocol();
        TransparencyLedger ledger = new TransparencyLedger();
        VerificationCodex codex = new VerificationCodex();

        // Reforms
        IntellectualDiversity diversity = new IntellectualDiversity();
        MarketAccountability accountability = new MarketAccountability();
        FundamentalEducation education = new FundamentalEducation();
        ResearchDecentralization research = new ResearchDecentralization();

        vm.stopBroadcast();
    }
}
