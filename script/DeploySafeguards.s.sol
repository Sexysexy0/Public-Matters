// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/VerificationCodex.sol";
import "../src/AccountabilityArc.sol";
import "../src/EvidenceRegistry.sol";
import "../src/SkepticismProtocol.sol";
import "../src/TransparencyLedger.sol";

contract DeploySafeguards is Script {
    function run() external {
        vm.startBroadcast();

        VerificationCodex codex = new VerificationCodex();
        console.log("VerificationCodex deployed at:", address(codex));

        AccountabilityArc arc = new AccountabilityArc();
        console.log("AccountabilityArc deployed at:", address(arc));

        EvidenceRegistry registry = new EvidenceRegistry();
        console.log("EvidenceRegistry deployed at:", address(registry));

        SkepticismProtocol protocol = new SkepticismProtocol();
        console.log("SkepticismProtocol deployed at:", address(protocol));

        TransparencyLedger ledger = new TransparencyLedger();
        console.log("TransparencyLedger deployed at:", address(ledger));

        vm.stopBroadcast();
    }
}
