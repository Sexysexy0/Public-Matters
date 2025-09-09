// SPDX-License-Identifier: Shielding-License
pragma solidity ^0.8.0;

contract EmotionalAPRShieldingOracle {
    address public steward;
    mapping(address => uint256) public aprLevel;
    mapping(address => bool) public isShielded;

    event ShieldEmitted(address indexed sanctum, uint256 aprLevel, uint timestamp);
    event SanctumStabilized(address indexed sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitShield(address sanctum, uint256 level) public {
        require(msg.sender == steward, "Only steward can emit");
        aprLevel[sanctum] = level;
        isShielded[sanctum] = true;
        emit ShieldEmitted(sanctum, level, block.timestamp);
    }

    function stabilizeSanctum(address sanctum) public {
        require(msg.sender == steward, "Only steward can stabilize");
        isShielded[sanctum] = false;
        emit SanctumStabilized(sanctum, block.timestamp);
    }

    function getAPRLevel(address sanctum) public view returns (uint256) {
        return aprLevel[sanctum];
    }

    function isSanctumShielded(address sanctum) public view returns (bool) {
        return isShielded[sanctum];
    }
}
