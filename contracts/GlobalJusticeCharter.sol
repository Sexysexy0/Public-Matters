// SPDX-License-Identifier: MIT
// Contract Name: GlobalJusticeCharter
// Purpose: Guarantee justice and fairness globally
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GlobalJusticeCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Justice {
        string domain;          // e.g., International, Community, Digital
        string justiceRule;     // e.g., Equality, Non-exploitation, Cooperative justice
        string safeguard;       // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    Justice[] public justices;

    event JusticeAdded(string domain, string justiceRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new global justice charter
    function addJustice(string memory domain, string memory justiceRule, string memory safeguard) public onlyChief {
        justices.push(Justice(domain, justiceRule, safeguard, block.timestamp));
        charterCount++;
        emit JusticeAdded(domain, justiceRule, safeguard, block.timestamp);
    }

    // View global justice details
    function getJustice(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < justices.length, "Invalid justice index");
        Justice memory j = justices[index];
        return (j.domain, j.justiceRule, j.safeguard, j.timestamp);
    }
}
