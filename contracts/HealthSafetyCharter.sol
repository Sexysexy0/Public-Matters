// SPDX-License-Identifier: MIT
// Contract Name: HealthSafetyCharter
// Purpose: Guarantee health and safety safeguards
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract HealthSafetyCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Safety {
        string domain;          // e.g., Workplace, Community, Digital
        string safeguard;       // e.g., PPE, Emergency drills, Cyber hygiene
        string enforcement;     // e.g., Audit, Compliance check, Public log
        uint256 timestamp;
    }

    Safety[] public safeties;

    event SafetyAdded(string domain, string safeguard, string enforcement, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new safety charter
    function addSafety(string memory domain, string memory safeguard, string memory enforcement) public onlyChief {
        safeties.push(Safety(domain, safeguard, enforcement, block.timestamp));
        charterCount++;
        emit SafetyAdded(domain, safeguard, enforcement, block.timestamp);
    }

    // View safety charter details
    function getSafety(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < safeties.length, "Invalid safety index");
        Safety memory s = safeties[index];
        return (s.domain, s.safeguard, s.enforcement, s.timestamp);
    }
}
