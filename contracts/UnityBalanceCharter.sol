// SPDX-License-Identifier: MIT
// Contract Name: UnityBalanceCharter
// Purpose: Encode fairness and equal benefit for the majority
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract UnityBalanceCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string unityMechanism;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string unityMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new unity balance charter
    function addCharter(string memory principle, string memory unityMechanism) public onlyChief {
        charters.push(Charter(principle, unityMechanism, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, unityMechanism, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.unityMechanism, c.timestamp);
    }
}
