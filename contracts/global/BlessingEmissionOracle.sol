// SPDX-License-Identifier: Blessing-License
pragma solidity ^0.8.0;

contract BlessingEmissionOracle {
    address public steward;
    mapping(address => uint256) public blessingLevel;
    mapping(address => bool) public sanctumStatus;

    event BlessingEmitted(address indexed sanctum, uint256 level, uint timestamp);
    event SanctumPurified(address indexed sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(address sanctum, uint256 level) public {
        require(msg.sender == steward, "Only steward can emit");
        blessingLevel[sanctum] = level;
        sanctumStatus[sanctum] = true;
        emit BlessingEmitted(sanctum, level, block.timestamp);
    }

    function purifySanctum(address sanctum) public {
        require(msg.sender == steward, "Only steward can purify");
        sanctumStatus[sanctum] = false;
        emit SanctumPurified(sanctum, block.timestamp);
    }

    function getBlessingLevel(address sanctum) public view returns (uint256) {
        return blessingLevel[sanctum];
    }

    function isSanctumBlessed(address sanctum) public view returns (bool) {
        return sanctumStatus[sanctum];
    }
}
