// SPDX-License-Identifier: MIT
// Contract Name: OracleBridgeCovenant
// Purpose: Connect trusted external data sources to governance system
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract OracleBridgeCovenant {
    address public chiefOperator;
    uint256 public bridgeCount;

    struct OracleBridge {
        string principle;
        string dataSource;
        uint256 timestamp;
    }

    OracleBridge[] public bridges;

    event OracleBridgeAdded(string principle, string dataSource, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        bridgeCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new oracle bridge clause
    function addBridge(string memory principle, string memory dataSource) public onlyChief {
        bridges.push(OracleBridge(principle, dataSource, block.timestamp));
        bridgeCount++;
        emit OracleBridgeAdded(principle, dataSource, block.timestamp);
    }

    // View bridge details
    function getBridge(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < bridges.length, "Invalid bridge index");
        OracleBridge memory ob = bridges[index];
        return (ob.principle, ob.dataSource, ob.timestamp);
    }
}
