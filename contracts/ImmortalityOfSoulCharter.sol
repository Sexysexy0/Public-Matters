// SPDX-License-Identifier: MIT
// Contract Name: ImmortalityOfSoulCharter
// Purpose: Establish spiritual foundation as counterbalance to materialism
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract ImmortalityOfSoulCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string foundation;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string foundation, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new soul charter clause
    function addCharter(string memory principle, string memory foundation) public onlyChief {
        charters.push(Charter(principle, foundation, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, foundation, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.foundation, c.timestamp);
    }
}
