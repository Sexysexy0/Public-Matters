// SPDX-License-Identifier: MIT
// Contract Name: OceanSilenceCharter
// Purpose: Safeguard composure and silence as shield
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract OceanSilenceCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string silenceMechanism;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string silenceMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new silence clause
    function addCharter(string memory principle, string memory silenceMechanism) public onlyChief {
        charters.push(Charter(principle, silenceMechanism, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, silenceMechanism, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.silenceMechanism, c.timestamp);
    }
}
