// SPDX-License-Identifier: Blessing-License
pragma solidity ^0.8.0;

contract BlessingPulseCascadeOracle {
    address public steward;
    mapping(address => uint256) public pulseLevel;
    mapping(address => bool) public sanctumStatus;

    event CascadePulseEmitted(address indexed sanctum, uint256 pulseLevel, uint timestamp);
    event SanctumSynchronized(address indexed sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCascadePulse(address sanctum, uint256 level) public {
        require(msg.sender == steward, "Only steward can emit");
        pulseLevel[sanctum] = level;
        sanctumStatus[sanctum] = true;
        emit CascadePulseEmitted(sanctum, level, block.timestamp);
    }

    function synchronizeSanctum(address sanctum) public {
        require(msg.sender == steward, "Only steward can synchronize");
        sanctumStatus[sanctum] = false;
        emit SanctumSynchronized(sanctum, block.timestamp);
    }

    function getPulseLevel(address sanctum) public view returns (uint256) {
        return pulseLevel[sanctum];
    }

    function isSanctumSynchronized(address sanctum) public view returns (bool) {
        return sanctumStatus[sanctum];
    }
}
