// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ProjectMilestoneEscrow.sol";

// Minimal mock Vault for testing purposes
contract MockVault {
    address public lastRecipient;
    uint256 public lastAmount;
    function submitTransaction(address payable _to, uint256 _value, bytes calldata) external returns (uint256) {
        lastRecipient = _to;
        lastAmount = _value;
        return 1;
    }
}

contract ProjectMilestoneEscrowTest is Test {
    ProjectMilestoneEscrow public escrow;
    MockVault public mockVault;

    function setUp() public {
        mockVault = new MockVault();
        escrow = new ProjectMilestoneEscrow(address(mockVault));
    }

    function test_CreateAndCompleteMilestone() public {
        string[] memory descs = new string[](2);
        descs[0] = "Phase 1 - Research";
        descs[1] = "Phase 2 - Development";

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10 ether;
        amounts[1] = 20 ether;

        uint256 id = escrow.createProject(1, payable(address(0x123)), descs, amounts);

        // Complete Phase 1
        escrow.completeMilestone(id, 0);

        // Verify the mock vault received the transaction
        assertEq(mockVault.lastRecipient(), address(0x123));
        assertEq(mockVault.lastAmount(), 10 ether);
    }
}
