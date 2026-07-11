// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSCommandCovenant
// Purpose: Encodes operational commands, execution safeguards, and enforcement protocols
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSCommandCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Command {
        string directive;     // Operational command issued
        string scope;         // Domain or area of enforcement
        string safeguard;     // Validation, accountability, discipline
        uint256 timestamp;
    }

    Command[] public commands;

    event CommandIssued(string directive, string scope, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function issueCommand(string memory directive, string memory scope, string memory safeguard) public onlyChief {
        commands.push(Command(directive, scope, safeguard, block.timestamp));
        covenantCount++;
        emit CommandIssued(directive, scope, safeguard, block.timestamp);
    }

    function getCommand(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < commands.length, "Invalid command index");
        Command memory c = commands[index];
        return (c.directive, c.scope, c.safeguard, c.timestamp);
    }
}
