// SPDX-License-Identifier: Scrollchain-Audit
pragma solidity ^0.8.0;

contract ClimateMismanagementReport {
    address public steward;

    struct Violation {
        string region;
        string policy;
        string consequence;
        uint timestamp;
    }

    Violation[] public violations;

    event ViolationLogged(string region, string policy, string consequence, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logViolation(string memory region, string memory policy, string memory consequence) public {
        require(msg.sender == steward, "Access denied");
        violations.push(Violation(region, policy, consequence, block.timestamp));
        emit ViolationLogged(region, policy, consequence, block.timestamp);
    }
}
