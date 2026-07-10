// SPDX-License-Identifier: MIT
// Contract Name: FamilyTransmissionCharter
// Purpose: Protect the nuclear family as harbor of faith and values
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract FamilyTransmissionCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string safeguard;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new family transmission charter
    function addCharter(string memory principle, string memory safeguard) public onlyChief {
        charters.push(Charter(principle, safeguard, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, safeguard, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.safeguard, c.timestamp);
    }
}
