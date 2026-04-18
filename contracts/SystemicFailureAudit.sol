// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SystemicFailureAudit {
    struct SocialIssue {
        string description;
        uint256 yearsPersisting;
        bool isToleratedBySociety;
    }

    // [1:10] Edu: "Problems for decades are no longer accidents"
    function auditService(string memory _issue, uint256 _years) public pure returns (string memory) {
        if (_years >= 10) {
            return "SYSTEMIC FAILURE DETECTED: This is a tolerated norm, not an accident.";
        }
        return "Operational Issue: Under monitoring.";
    }
}
