// SPDX-License-Identifier: MIT
// Contract Name: AttendanceHarmonyPact
// Purpose: Ensure fair attendance rules and harmony safeguards
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract AttendanceHarmonyPact {
    address public chiefOperator;
    uint256 public pactCount;

    struct Pact {
        string ruleType;        // e.g., Time-in, Time-out, Flexi-hours
        string fairnessRule;    // e.g., Equal treatment, Grace period
        string safeguard;       // e.g., Transparency log, Audit
        uint256 timestamp;
    }

    Pact[] public pacts;

    event PactAdded(string ruleType, string fairnessRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        pactCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new attendance pact
    function addPact(string memory ruleType, string memory fairnessRule, string memory safeguard) public onlyChief {
        pacts.push(Pact(ruleType, fairnessRule, safeguard, block.timestamp));
        pactCount++;
        emit PactAdded(ruleType, fairnessRule, safeguard, block.timestamp);
    }

    // View attendance pact details
    function getPact(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < pacts.length, "Invalid pact index");
        Pact memory p = pacts[index];
        return (p.ruleType, p.fairnessRule, p.safeguard, p.timestamp);
    }
}
