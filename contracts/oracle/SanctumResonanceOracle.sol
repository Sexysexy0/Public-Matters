// SPDX-License-Identifier: Resonance-License
pragma solidity ^0.8.0;

contract SanctumResonanceOracle {
    address public steward;
    mapping(string => uint256) public resonanceLevel;
    mapping(string => bool) public isHarmonic;

    event ResonancePulseEmitted(string sanctum, uint256 level, uint timestamp);
    event SanctumHarmonized(string sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitResonancePulse(string memory sanctum, uint256 level) public {
        require(msg.sender == steward, "Only steward can emit");
        resonanceLevel[sanctum] = level;
        isHarmonic[sanctum] = true;
        emit ResonancePulseEmitted(sanctum, level, block.timestamp);
        emit SanctumHarmonized(sanctum, block.timestamp);
    }

    function getResonanceLevel(string memory sanctum) public view returns (uint256) {
        return resonanceLevel[sanctum];
    }

    function isSanctumHarmonized(string memory sanctum) public view returns (bool) {
        return isHarmonic[sanctum];
    }
}
