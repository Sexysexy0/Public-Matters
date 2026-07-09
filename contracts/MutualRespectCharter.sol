// SPDX-License-Identifier: MIT
// Contract Name: MutualRespectCharter
// Purpose: Guarantee mutual respect and recognition
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MutualRespectCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Respect {
        string domain;           // e.g., Workplace, Community, Global
        string respectRule;      // e.g., Courtesy, Recognition, Anti-disrespect safeguard
        string safeguard;        // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    Respect[] public respects;

    event RespectAdded(string domain, string respectRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new mutual respect charter
    function addRespect(string memory domain, string memory respectRule, string memory safeguard) public onlyChief {
        respects.push(Respect(domain, respectRule, safeguard, block.timestamp));
        charterCount++;
        emit RespectAdded(domain, respectRule, safeguard, block.timestamp);
    }

    // View mutual respect details
    function getRespect(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < respects.length, "Invalid respect index");
        Respect memory r = respects[index];
        return (r.domain, r.respectRule, r.safeguard, r.timestamp);
    }
}
