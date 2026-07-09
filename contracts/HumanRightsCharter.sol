// SPDX-License-Identifier: MIT
// Contract Name: HumanRightsCharter
// Purpose: Guarantee fundamental human rights protections
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract HumanRightsCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Right {
        string category;        // e.g., Life, Liberty, Security
        string protectionRule;  // e.g., Equal treatment, Non-discrimination, Freedom safeguard
        string safeguard;       // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    Right[] public rights;

    event RightAdded(string category, string protectionRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new human right
    function addRight(string memory category, string memory protectionRule, string memory safeguard) public onlyChief {
        rights.push(Right(category, protectionRule, safeguard, block.timestamp));
        charterCount++;
        emit RightAdded(category, protectionRule, safeguard, block.timestamp);
    }

    // View human right details
    function getRight(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < rights.length, "Invalid right index");
        Right memory r = rights[index];
        return (r.category, r.protectionRule, r.safeguard, r.timestamp);
    }
}
