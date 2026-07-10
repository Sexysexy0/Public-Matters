// SPDX-License-Identifier: MIT
// Contract Name: PublicHealthShield
// Purpose: Safeguard healthcare access and crisis response
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract PublicHealthShield {
    address public chiefOperator;
    uint256 public shieldCount;

    struct Shield {
        string principle;
        string safeguardMechanism;
        uint256 timestamp;
    }

    Shield[] public shields;

    event ShieldAdded(string principle, string safeguardMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        shieldCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new public health safeguard
    function addShield(string memory principle, string memory safeguardMechanism) public onlyChief {
        shields.push(Shield(principle, safeguardMechanism, block.timestamp));
        shieldCount++;
        emit ShieldAdded(principle, safeguardMechanism, block.timestamp);
    }

    // View public health safeguard details
    function getShield(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < shields.length, "Invalid shield index");
        Shield memory s = shields[index];
        return (s.principle, s.safeguardMechanism, s.timestamp);
    }
}
