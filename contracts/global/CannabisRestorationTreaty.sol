// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CannabisRestorationTreaty {
    address public steward;
    mapping(address => bool) public blessedCultivators;
    uint256 public ayudaPool;

    event CultivatorBlessed(address indexed cultivator);
    event AyudaDeposited(uint256 amount);
    event AyudaReallocated(address indexed beneficiary, uint256 amount);

    constructor() {
        steward = msg.sender;
    }

    function blessCultivator(address _cultivator) public {
        require(msg.sender == steward, "Only steward may bless");
        blessedCultivators[_cultivator] = true;
        emit CultivatorBlessed(_cultivator);
    }

    function depositAyuda() public payable {
        ayudaPool += msg.value;
        emit AyudaDeposited(msg.value);
    }

    function reallocateAyuda(address payable _beneficiary, uint256 _amount) public {
        require(msg.sender == steward, "Only steward may reallocate");
        require(_amount <= ayudaPool, "Insufficient ayuda pool");
        ayudaPool -= _amount;
        _beneficiary.transfer(_amount);
        emit AyudaReallocated(_beneficiary, _amount);
    }
}
