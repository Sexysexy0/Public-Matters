// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SalvageRefunds {
    // [Goal: Allow players to recover artifacts from decommissioned gear]
    function calculateRefund(uint256 _spentArtifacts) external pure returns (uint256) {
        // Returns 75% of materials back to the player
        return (_spentArtifacts * 75) / 100;
    }
}
