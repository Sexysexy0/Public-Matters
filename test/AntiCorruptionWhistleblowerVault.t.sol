// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AntiCorruptionWhistleblowerVault.sol";

contract AntiCorruptionWhistleblowerVaultTest is Test {
    AntiCorruptionWhistleblowerVault public vault;

    address public owner = address(this);
    address public auditor1 = makeAddr("auditor1");
    address public auditor2 = makeAddr("auditor2");
    address public auditor3 = makeAddr("auditor3");

    address public whistleblower = makeAddr("whistleblower");

    function setUp() public {
        vault = new AntiCorruptionWhistleblowerVault();
        vault.addAuditor(auditor1);
        vault.addAuditor(auditor2);
        vault.addAuditor(auditor3);
        // Fund the contract for bounty
        vm.deal(address(vault), 10 ether);
    }

    function test_ReportAndClaimFlow() public {
        bytes32 evidence = keccak256(abi.encodePacked("CorruptionEvidence.pdf"));
        bytes32 secretKey = keccak256(abi.encodePacked("WhistleblowerSecret123"));
        
        // Whistleblower computes the commitment off-chain
        bytes32 commitment = keccak256(abi.encodePacked(secretKey, whistleblower));

        // 1. Submit anonymous report (caller is the burner wallet)
        vm.prank(whistleblower);
        uint256 reportId = vault.submitReport(evidence, commitment, 1 ether);

        // 2. Auditors verify the report
        vm.prank(auditor1); vault.verifyReport(reportId);
        vm.prank(auditor2); vault.verifyReport(reportId);
        vm.prank(auditor3); vault.verifyReport(reportId);

        // 3. Claim bounty using the secret key
        uint256 balanceBefore = whistleblower.balance;
        vm.prank(whistleblower);
        vault.claimBounty(reportId, secretKey);

        assertEq(whistleblower.balance - balanceBefore, 1 ether);
    }
}
