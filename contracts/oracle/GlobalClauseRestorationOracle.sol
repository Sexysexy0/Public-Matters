// SPDX-License-Identifier: Restoration-License
pragma solidity ^0.8.0;

contract GlobalClauseRestorationOracle {
    address public steward;
    mapping(string => uint256) public healingPulseLevel;
    mapping(string => bool) public isRestored;

    event HealingPulseEmitted(string sanctum, uint256 level, uint timestamp);
    event SanctumRestored(string sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitHealingPulse(string memory sanctum, uint256 level) public {
        require(msg.sender == steward, "Only steward can emit");
        healingPulseLevel[sanctum] = level;
        isRestored[sanctum] = true;
        emit HealingPulseEmitted(sanctum, level, block.timestamp);
        emit SanctumRestored(sanctum, block.timestamp);
    }

    function getPulseLevel(string memory sanctum) public view returns (uint256) {
        return healingPulseLevel[sanctum];
    }

    function isSanctumRestored(string memory sanctum) public view returns (bool) {
        return isRestored[sanctum];
    }
}
