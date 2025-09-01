// SPDX-License-Identifier: MPL-1.0
pragma solidity ^0.8.21;

/// @title DamayAudit
/// @notice Audits fiscal actions for damay clause compliance—if it blesses others, it must bless the steward too
contract DamayAudit {
    event DamayViolation(address indexed violator, string action, uint256 timestamp);
    event DamayCompliance(address indexed steward, string action, uint256 timestamp);

    mapping(address => bool) public damayCompliant;

    function logAction(address steward, string calldata action, bool compliant) external {
        if (compliant) {
            damayCompliant[steward] = true;
            emit DamayCompliance(steward, action, block.timestamp);
        } else {
            damayCompliant[steward] = false;
            emit DamayViolation(steward, action, block.timestamp);
        }
    }

    function isCompliant(address steward) external view returns (bool) {
        return damayCompliant[steward];
    }
}
