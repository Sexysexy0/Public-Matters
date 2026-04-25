// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CannabisRescheduleLedger {
    struct Operator { address entity; bool compliant; }
    mapping(address => Operator) public operators;

    event ComplianceTokenIssued(address entity);

    function registerOperator() external {
        operators[msg.sender] = Operator(msg.sender, true);
        emit ComplianceTokenIssued(msg.sender);
        // EFFECT: 280E relief activated for Schedule III compliance.
    }
}
