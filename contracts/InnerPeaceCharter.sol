// SPDX-License-Identifier: MIT
// Contract Name: InnerPeaceCharter
// Purpose: Safeguard systemic calmness and composure
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract InnerPeaceCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string peaceMechanism;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string peaceMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new inner peace clause
    function addCharter(string memory principle, string memory peaceMechanism) public onlyChief {
        charters.push(Charter(principle, peaceMechanism, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, peaceMechanism, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.peaceMechanism, c.timestamp);
    }
}
