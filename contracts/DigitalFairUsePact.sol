// SPDX-License-Identifier: MIT
// Contract Name: DigitalFairUsePact
// Purpose: Safeguard fair use rights in digital media and innovation
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract DigitalFairUsePact {
    address public chiefOperator;
    uint256 public pactCount;

    struct Pact {
        string principle;
        string fairUseMechanism;
        uint256 timestamp;
    }

    Pact[] public pacts;

    event PactAdded(string principle, string fairUseMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        pactCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new fair use clause
    function addPact(string memory principle, string memory fairUseMechanism) public onlyChief {
        pacts.push(Pact(principle, fairUseMechanism, block.timestamp));
        pactCount++;
        emit PactAdded(principle, fairUseMechanism, block.timestamp);
    }

    // View fair use details
    function getPact(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < pacts.length, "Invalid pact index");
        Pact memory p = pacts[index];
        return (p.principle, p.fairUseMechanism, p.timestamp);
    }
}
