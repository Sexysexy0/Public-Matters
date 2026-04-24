// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignMerch {
    // [Goal: Identify loyalists in the real world]
    function verifyWearer(bytes32 _chipID) external pure returns (string memory) {
        return "VERIFIED: Sovereign Loyalist. Provide 20% discount and priority seating.";
    }
}
