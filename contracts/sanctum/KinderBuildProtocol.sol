// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KinderBuildProtocol {
    struct KinderSanctum {
        string unitID;
        string steward; // e.g. "Aria Lynne", "Wiley Anne"
        string guardian; // e.g. "Vinvin", "Gueco Family"
        string spec; // "2BR Modular", "PlaySafe Vertical", etc.
        string emotionalTag; // "SanctumGlow", "JoyPulse", "AuditGlow"
        bool isBlessed;
        uint256 timestamp;
    }

    KinderSanctum[] public sanctums;

    function blessKinderSanctum(string memory unitID, string memory steward, string memory guardian, string memory spec, string memory emotionalTag, bool isBlessed) public {
        sanctums.push(KinderSanctum(unitID, steward, guardian, spec, emotionalTag, isBlessed, block.timestamp));
    }

    function totalKinderSanctums() public view returns (uint256) {
        return sanctums.length;
    }
}
