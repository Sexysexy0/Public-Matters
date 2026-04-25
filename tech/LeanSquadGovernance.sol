// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LeanSquadGovernance {
    // [Goal: Enforce small, high-fidelity team structures for maximum agility]
    function allocateBudget(uint256 _teamSize) external pure returns (string memory) {
        if (_teamSize > 15) {
            return "REJECTED: Team too bloated. Complexity risk detected.";
        }
        return "APPROVED: Lean Squad active. High-speed execution authorized.";
    }
}
