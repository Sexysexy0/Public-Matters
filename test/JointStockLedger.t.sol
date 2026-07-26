// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../contracts/governance/JointStockGovernanceLedger.sol";
import "../contracts/governance/InstitutionalAuditHistory.sol";
import "../contracts/governance/GovernanceSimulation.sol";

contract JointStockLedgerTest is Test {
    JointStockGovernanceLedger ledger;
    InstitutionalAuditHistory audit;
    GovernanceSimulation sim;

    function setUp() public {
        audit = new InstitutionalAuditHistory();
        sim = new GovernanceSimulation();
        ledger = new JointStockGovernanceLedger(address(audit), address(sim));
    }

    function testIssueSharesGasBenchmark() public {
        uint256 gasBefore = gasleft();
        ledger.issueShares(address(this), 100);
        uint256 gasUsed = gasBefore - gasleft();
        assertLt(gasUsed, 120000, "Gas too high for issueShares");
    }

    function testTransferSharesGasBenchmark() public {
        ledger.issueShares(address(this), 50);
        uint256 gasBefore = gasleft();
        ledger.transferShares(address(1), 20);
        uint256 gasUsed = gasBefore - gasleft();
        assertLt(gasUsed, 150000, "Gas too high for transferShares");
    }

    function testTransferFailsWithoutShares() public {
        vm.expectRevert("Not a shareholder");
        ledger.transferShares(address(1), 10);
    }

    function testTransferFailsInsufficientBalance() public {
        ledger.issueShares(address(this), 5);
        vm.expectRevert("Insufficient shares");
        ledger.transferShares(address(1), 10);
    }
}
