// SPDX-License-Identifier: MIT
// Contract Name: HumanRightsCovenant
// Purpose: Guarantee universal human rights protection
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract HumanRightsCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Right {
        string domain;          // e.g., Workplace, Community, Digital
        string rightRule;       // e.g., Life, Liberty, Equality, Dignity
        string safeguard;       // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    Right[] public rights;

    event RightAdded(string domain, string rightRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new human rights covenant
    function addRight(string memory domain, string memory rightRule, string memory safeguard) public onlyChief {
        rights.push(Right(domain, rightRule, safeguard, block.timestamp));
        covenantCount++;
        emit RightAdded(domain, rightRule, safeguard, block.timestamp);
    }

    // View human rights covenant details
    function getRight(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < rights.length, "Invalid right index");
        Right memory r = rights[index];
        return (r.domain, r.rightRule, r.safeguard, r.timestamp);
    }
}
