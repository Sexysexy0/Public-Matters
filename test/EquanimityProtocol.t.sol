// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/optimization/EquanimityProtocol.sol";

contract EquanimityProtocolTest is Test {
    EquanimityProtocol public equanimity;

    bytes32 public sampleProofHash = keccak256(abi.encodePacked("NON_BIAS_PROOF_DATA_123"));

    function setUp() external {
        equanimity = new EquanimityProtocol();
    }

    function test_AlignStateSuccess() external {
        // Assert initial state is false
        assertFalse(equanimity.isAligned(sampleProofHash));

        // Align state
        equanimity.alignState(sampleProofHash);

        // Assert state is now true
        assertTrue(equanimity.isAligned(sampleProofHash));
    }

    function test_RevertIfAlreadyAligned() external {
        equanimity.alignState(sampleProofHash);

        // Expect revert on second attempt
        vm.expectRevert("Equanimity: State already executed");
        equanimity.alignState(sampleProofHash);
    }
}
