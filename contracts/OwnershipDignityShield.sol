// SPDX-License-Identifier: MIT
// Contract Name: OwnershipDignityShield
// Purpose: Protect worker dignity and ownership rights
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract OwnershipDignityShield {
    address public chiefOperator;
    uint256 public shieldCount;

    struct Shield {
        string rightType;       // e.g., Worker dignity, Ownership respect
        string safeguard;       // e.g., Non-discrimination, Equal treatment
        string enforcement;     // e.g., Audit, Complaint resolution
        uint256 timestamp;
    }

    Shield[] public shields;

    event ShieldAdded(string rightType, string safeguard, string enforcement, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        shieldCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new dignity shield
    function addShield(string memory rightType, string memory safeguard, string memory enforcement) public onlyChief {
        shields.push(Shield(rightType, safeguard, enforcement, block.timestamp));
        shieldCount++;
        emit ShieldAdded(rightType, safeguard, enforcement, block.timestamp);
    }

    // View shield details
    function getShield(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < shields.length, "Invalid shield index");
        Shield memory s = shields[index];
        return (s.rightType, s.safeguard, s.enforcement, s.timestamp);
    }
}
