// SPDX-License-Identifier: MIT
// Contract Name: RepairPreservationCharter
// Purpose: Safeguard right to repair and preserve physical copies
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract RepairPreservationCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string safeguardMechanism;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string safeguardMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new repair + preservation clause
    function addCharter(string memory principle, string memory safeguardMechanism) public onlyChief {
        charters.push(Charter(principle, safeguardMechanism, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, safeguardMechanism, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.safeguardMechanism, c.timestamp);
    }
}
