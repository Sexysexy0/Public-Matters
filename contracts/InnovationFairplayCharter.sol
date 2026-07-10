// SPDX-License-Identifier: MIT
// Contract Name: InnovationFairplayCharter
// Purpose: Safeguard fairness in innovation, prevent exploitative practices
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract InnovationFairplayCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string fairplayMechanism;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string fairplayMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new fairplay clause
    function addCharter(string memory principle, string memory fairplayMechanism) public onlyChief {
        charters.push(Charter(principle, fairplayMechanism, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, fairplayMechanism, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.fairplayMechanism, c.timestamp);
    }
}
