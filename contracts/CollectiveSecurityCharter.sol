// SPDX-License-Identifier: MIT
// Contract Name: CollectiveSecurityCharter
// Purpose: Guarantee shared security and mutual defense
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CollectiveSecurityCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Security {
        string domain;          // e.g., Workplace, Community, Digital
        string securityRule;    // e.g., Mutual defense, Equal protection, Non-escalation
        string safeguard;       // e.g., Transparency log, Audit, Compliance check
        uint256 timestamp;
    }

    Security[] public securities;

    event SecurityAdded(string domain, string securityRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new collective security charter
    function addSecurity(string memory domain, string memory securityRule, string memory safeguard) public onlyChief {
        securities.push(Security(domain, securityRule, safeguard, block.timestamp));
        charterCount++;
        emit SecurityAdded(domain, securityRule, safeguard, block.timestamp);
    }

    // View collective security details
    function getSecurity(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < securities.length, "Invalid security index");
        Security memory s = securities[index];
        return (s.domain, s.securityRule, s.safeguard, s.timestamp);
    }
}
