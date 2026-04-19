// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EvidenceBasedJustice {
    // [6:27-10:55] Cases should only be filed with reasonable certainty of conviction
    function validateCase(uint256 _evidenceStrength, bool _isDeadlineDriven) public pure returns (bool) {
        if (_isDeadlineDriven && _evidenceStrength < 75) {
            // "Avoid performative justice and waste of court resources."
            return false;
        }
        return true; 
    }
}
