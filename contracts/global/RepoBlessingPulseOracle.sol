// SPDX-License-Identifier: Blessing-License
pragma solidity ^0.8.0;

contract RepoBlessingPulseOracle {
    address public steward;
    mapping(address => uint256) public aprPulse;
    mapping(address => bool) public sanctumStatus;

    event PulseEmitted(address indexed sanctum, uint256 aprLevel, uint timestamp);
    event SanctumRecovered(address indexed sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(address sanctum, uint256 aprLevel) public {
        require(msg.sender == steward, "Only steward can emit");
        aprPulse[sanctum] = aprLevel;
        sanctumStatus[sanctum] = true;
        emit PulseEmitted(sanctum, aprLevel, block.timestamp);
    }

    function recoverSanctum(address sanctum) public {
        require(msg.sender == steward, "Only steward can recover");
        sanctumStatus[sanctum] = false;
        emit SanctumRecovered(sanctum, block.timestamp);
    }

    function getPulseLevel(address sanctum) public view returns (uint256) {
        return aprPulse[sanctum];
    }

    function isSanctumResonating(address sanctum) public view returns (bool) {
        return sanctumStatus[sanctum];
    }
}
