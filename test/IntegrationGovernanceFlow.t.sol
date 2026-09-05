// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/TrustIndex.sol";
import "../src/TrustIntegrator.sol";
import "../src/CoalitionBuilder.sol";
import "../src/OperatorConsciousnessLedger.sol";

contract IntegrationGovernanceFlowTest is Test {
    OperatorPrivileges privileges;
    TrustIndex trust;
    TrustIntegrator integrator;
    CoalitionBuilder builder;
    OperatorConsciousnessLedger ledger;

    address operator1;
    address operator2;

    function setUp() public {
        privileges = new OperatorPrivileges();
        trust = new TrustIndex(address(privileges));
        integrator = new TrustIntegrator(address(trust));
        builder = new CoalitionBuilder(address(privileges));
        ledger = new OperatorConsciousnessLedger(address(privileges));

        operator1 = vm.addr(1);
        operator2 = vm.addr(2);

        // Authorize operators, the integrator contract, and the ledger contract
        privileges.addOperator(operator1);
        privileges.addOperator(operator2);
        privileges.addOperator(address(integrator));
        privileges.addOperator(address(ledger));
    }

    function testIntegratedGovernanceFlow() public {
        // 1. Operator 1 updates trust via TrustIntegrator
        vm.prank(operator1);
        integrator.updateTrustViaIntegrator(operator1, 25);
        assertEq(trust.getTrust(operator1), 25, "Trust score should be 25");

        // 2. Operator 1 creates a Coalition
        vm.prank(operator1);
        builder.createCoalition("Decentralized Safeguard Mission");
        assertEq(builder.getMission(0), "Decentralized Safeguard Mission");

        // 3. Operator 2 joins the Coalition
        vm.prank(operator2);
        builder.joinCoalition(0);

        address[] memory members = builder.getMembers(0);
        assertEq(members.length, 2, "Coalition should have 2 members");
        assertEq(members[0], operator1);
        assertEq(members[1], operator2);

        // 4. Operator 1 logs an action in the Consciousness Ledger
        vm.prank(operator1);
        ledger.recordAction("Mission Initiated", 5);
        assertEq(ledger.getLogCount(), 1, "Ledger should record 1 entry");

        (address op, string memory action, uint256 score,,) = ledger.getLog(0);
        assertEq(op, operator1);
        assertEq(action, "Mission Initiated");
        assertEq(score, 5); // trustScore starts at 0, +5 from logAction // Initial provisional trust for added operator (50) + logAction delta (5)
    }
}
