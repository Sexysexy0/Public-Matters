// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/DisputeResolutionArbitration.sol";

contract DisputeResolutionArbitrationTest is Test {
    DisputeResolutionArbitration public arbitration;

    function setUp() public {
        arbitration = new DisputeResolutionArbitration();
    }

    function test_RaiseAndResolveDispute() public {
        bytes32 hash = keccak256(abi.encodePacked("Breach of Contract Evidence"));
        
        // Raise a dispute
        uint256 id = arbitration.raiseDispute(42, address(0xBAD), hash);
        
        DisputeResolutionArbitration.Dispute memory dispute = arbitration.getDispute(id);
        
        assertEq(dispute.treatyId, 42);
        assertEq(dispute.evidenceHash, hash);
        assertEq(uint8(dispute.status), uint8(DisputeResolutionArbitration.DisputeStatus.DISPUTED));

        // Resolve the dispute in favor of the disputant
        arbitration.resolveDispute(id, true);
        
        DisputeResolutionArbitration.Dispute memory disputeResolved = arbitration.getDispute(id);
        assertEq(uint8(disputeResolved.status), uint8(DisputeResolutionArbitration.DisputeStatus.RESOLVED));
    }
}
