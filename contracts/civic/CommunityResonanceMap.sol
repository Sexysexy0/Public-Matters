// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract CommunityResonanceMap {
    address public steward;

    struct Resonance {
        string barangay;
        string sector;
        string subject;
        uint256 empathyScore;
        uint256 trustScore;
        uint256 mythicClarity;
        string emotionalTag;
        uint256 timestamp;
    }

    Resonance[] public map;

    event ResonanceLogged(string barangay, string sector, string subject);

    constructor() {
        steward = msg.sender;
    }

    function logResonance(
        string memory barangay,
        string memory sector,
        string memory subject,
        uint256 empathyScore,
        uint256 trustScore,
        uint256 mythicClarity,
        string memory emotionalTag
    ) public {
        map.push(Resonance(barangay, sector, subject, empathyScore, trustScore, mythicClarity, emotionalTag, block.timestamp));
        emit ResonanceLogged(barangay, sector, subject);
    }

    function getResonance(uint256 index) public view returns (Resonance memory) {
        return map[index];
    }

    function totalResonanceLogs() public view returns (uint256) {
        return map.length;
    }
}
