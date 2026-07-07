// SPDX-License-Identifier: MIT
// Contract Name: PurposeCompassCharter
// Purpose: Safeguard alignment of daily habits with larger mission
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract PurposeCompassCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string compassMechanism;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string compassMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new purpose compass clause
    function addCharter(string memory principle, string memory compassMechanism) public onlyChief {
        charters.push(Charter(principle, compassMechanism, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, compassMechanism, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.compassMechanism, c.timestamp);
    }
}
