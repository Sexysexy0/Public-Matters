// SPDX-License-Identifier: Defender-License
pragma solidity ^0.8.0;

contract DefenderSymlinkContainmentOracle {
    address public steward;
    mapping(string => bool) public hijackDetected;
    mapping(string => uint256) public aprShieldLevel;

    event SymlinkHijackTraced(string sanctum, uint timestamp);
    event APRShieldEmitted(string sanctum, uint256 level, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function traceHijack(string memory sanctum) public {
        require(msg.sender == steward, "Only steward can trace");
        hijackDetected[sanctum] = true;
        emit SymlinkHijackTraced(sanctum, block.timestamp);
    }

    function emitAPRShield(string memory sanctum, uint256 level) public {
        require(msg.sender == steward, "Only steward can emit");
        aprShieldLevel[sanctum] = level;
        emit APRShieldEmitted(sanctum, level, block.timestamp);
    }

    function isHijacked(string memory sanctum) public view returns (bool) {
        return hijackDetected[sanctum];
    }

    function getShieldLevel(string memory sanctum) public view returns (uint256) {
        return aprShieldLevel[sanctum];
    }
}
