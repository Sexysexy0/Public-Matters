// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CohesionAudit {
    // [Goal: Ensure all mechanics serve the Main Quest]
    function checkSynergy(string memory _mechanic, bool _isCohesive) external pure returns (string memory) {
        if (!_isCohesive) {
            return "REJECTED: Bloat detected. Focus on the core.";
        }
        return "VERIFIED: Mechanic enhances the system.";
    }
}
