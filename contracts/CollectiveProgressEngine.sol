// SPDX-License-Identifier: MIT
// Contract Name: CollectiveProgressEngine
// Purpose: Drive shared progress for all stakeholders
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CollectiveProgressEngine {
    address public chiefOperator;
    uint256 public engineCount;

    struct Engine {
        string principle;
        string propulsionMechanism;
        uint256 timestamp;
    }

    Engine[] public engines;

    event EngineAdded(string principle, string propulsionMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        engineCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new collective progress engine clause
    function addEngine(string memory principle, string memory propulsionMechanism) public onlyChief {
        engines.push(Engine(principle, propulsionMechanism, block.timestamp));
        engineCount++;
        emit EngineAdded(principle, propulsionMechanism, block.timestamp);
    }

    // View engine details
    function getEngine(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < engines.length, "Invalid engine index");
        Engine memory e = engines[index];
        return (e.principle, e.propulsionMechanism, e.timestamp);
    }
}
