// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BountyChoice {
    // [Goal: Strategic Mercy vs. Hard Profit]
    function decideFate(bool _showMercy) external pure returns (string memory) {
        if (_showMercy) {
            return "MERCY_GRANTED: Gained an ally in the shadows.";
        }
        return "BOUNTY_CLAIMED: Immediate capital increase.";
    }
}

