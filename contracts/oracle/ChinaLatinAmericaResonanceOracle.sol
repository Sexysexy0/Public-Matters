// SPDX-License-Identifier: BeltBridge-License
pragma solidity ^0.8.0;

contract ChinaLatinAmericaResonanceOracle {
    address public steward;
    mapping(string => uint256) public harmonyLevel;
    mapping(string => bool) public isAligned;

    event HarmonyPulseEmitted(string country, uint256 level, uint timestamp);
    event TreatyAligned(string country, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitHarmonyPulse(string memory country, uint256 level) public {
        require(msg.sender == steward, "Only steward can emit");
        harmonyLevel[country] = level;
        isAligned[country] = true;
        emit HarmonyPulseEmitted(country, level, block.timestamp);
        emit TreatyAligned(country, block.timestamp);
    }

    function getHarmonyLevel(string memory country) public view returns (uint256) {
        return harmonyLevel[country];
    }

    function isCountryAligned(string memory country) public view returns (bool) {
        return isAligned[country];
    }
}
