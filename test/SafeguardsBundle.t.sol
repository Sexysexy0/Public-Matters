// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VerificationCodex.sol";
import "../src/AccountabilityArc.sol";
import "../src/EvidenceRegistry.sol";
import "../src/SkepticismProtocol.sol";
import "../src/TransparencyLedger.sol";

contract SafeguardsBundleTest is Test {
    VerificationCodex codex;
    AccountabilityArc arc;
    EvidenceRegistry registry;
    SkepticismProtocol protocol;
    TransparencyLedger ledger;

    function setUp() public {
        codex = new VerificationCodex();
        arc = new AccountabilityArc();
        registry = new EvidenceRegistry();
        protocol = new SkepticismProtocol();
        ledger = new TransparencyLedger();
    }

    function test_VerificationCodex() public {
        codex.addEntry("Proof A");
        assertEq(codex.getEntry(0), "Proof A");
    }

    function test_AccountabilityArc() public {
        arc.logAction("Audit completed");
        assertEq(arc.getAction(0), "Audit completed");
    }

    function test_EvidenceRegistry() public {
        registry.registerEvidence("Doc123");
        assertEq(registry.getEvidence(0), "Doc123");
    }

    function test_SkepticismProtocol() public {
        protocol.raiseFlag("Suspicious claim");
        assertEq(protocol.getFlag(0), "Suspicious claim");
    }

    function test_TransparencyLedger() public {
        ledger.logRecord("Budget published");
        assertEq(ledger.getRecord(0), "Budget published");
    }
}
