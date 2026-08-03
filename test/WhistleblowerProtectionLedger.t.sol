// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/WhistleblowerProtectionLedger.sol";

contract WhistleblowerProtectionLedgerTest is Test {
    WhistleblowerProtectionLedger public wpl;

    address public admin = address(this);
    address public auditor1 = makeAddr("auditor1");
    address public auditor2 = makeAddr("auditor2");
    address public whistleblower = makeAddr("burnerWallet");

    bytes32 public secretKey = keccak256(abi.encodePacked("WhistleblowerSecret123"));
    bytes32 public evidenceHash = keccak256(abi.encodePacked("EvidenceOfCorruptionDoc"));

    function setUp() public {
        // Deploy contract with 5 ETH bounty escrow pool
        wpl = new WhistleblowerProtectionLedger{value: 5 ether}();
        wpl.registerAuditor(auditor1);
        wpl.registerAuditor(auditor2);
    }

    function test_AnonymousReportAndBountyClaim() public {
        // Generate secret commitment for anonymous payout verification
        bytes32 secretCommitment = keccak256(abi.encodePacked(secretKey, whistleblower));

        // Submit report with requested 1 ETH bounty
        uint256 reportId = wpl.submitReport(evidenceHash, secretCommitment, 1 ether);

        // Auditors verify evidence
        vm.prank(auditor1);
        wpl.verifyReport(reportId);

        vm.prank(auditor2);
        wpl.verifyReport(reportId);

        uint256 preBalance = whistleblower.balance;

        // Whistleblower claims bounty anonymously using secret key from burner wallet
        vm.prank(whistleblower);
        wpl.claimBounty(reportId, secretKey);

        assertEq(whistleblower.balance - preBalance, 1 ether);
    }
}
