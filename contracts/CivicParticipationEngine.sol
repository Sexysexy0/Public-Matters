// SPDX-License-Identifier: MIT
// Contract Name: CivicParticipationEngine
// Purpose: Encode civic participation, accountability, and equal access to rights
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CivicParticipationEngine {
    address public chiefOperator;
    uint256 public engineCount;

    struct Engine {
        string principle;
        string participationMechanism;
        uint256 timestamp;
    }

    Engine[] public engines;

    event EngineAdded(string principle, string participationMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        engineCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new civic participation clause
    function addEngine(string memory principle, string memory participationMechanism) public onlyChief {
        engines.push(Engine(principle, participationMechanism, block.timestamp));
        engineCount++;
        emit EngineAdded(principle, participationMechanism, block.timestamp);
    }

    // View civic participation clause details
    function getEngine(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < engines.length, "Invalid engine index");
        Engine memory e = engines[index];
        return (e.principle, e.participationMechanism, e.timestamp);
    }
}
