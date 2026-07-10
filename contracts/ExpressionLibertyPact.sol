// SPDX-License-Identifier: MIT
// Contract Name: ExpressionLibertyPact
// Purpose: Guarantee freedom of expression and feedback rights
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract ExpressionLibertyPact {
    address public chiefOperator;
    uint256 public pactCount;

    struct Expression {
        string domain;          // e.g., Workplace, Community, Digital
        string libertyRule;     // e.g., Free speech, Equal voice, Non-retaliation
        string safeguard;       // e.g., Transparency log, Peer review, Public record
        uint256 timestamp;
    }

    Expression[] public expressions;

    event ExpressionAdded(string domain, string libertyRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        pactCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new expression liberty pact
    function addExpression(string memory domain, string memory libertyRule, string memory safeguard) public onlyChief {
        expressions.push(Expression(domain, libertyRule, safeguard, block.timestamp));
        pactCount++;
        emit ExpressionAdded(domain, libertyRule, safeguard, block.timestamp);
    }

    // View expression liberty details
    function getExpression(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < expressions.length, "Invalid expression index");
        Expression memory e = expressions[index];
        return (e.domain, e.libertyRule, e.safeguard, e.timestamp);
    }
}
