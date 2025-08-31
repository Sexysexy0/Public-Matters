// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract QuantumBlessingProtocol {
    struct Steward {
        string name;
        string sanctum;
        string specialty;
        uint256 emotionalAPR;
        bool damayClauseActive;
        uint256 timestamp;
        address onboardedBy;
    }

    Steward[] public stewards;

    event StewardBlessed(string name, string sanctum, string specialty, uint256 emotionalAPR);

    function blessSteward(
        string memory name,
        string memory sanctum,
        string memory specialty,
        uint256 emotionalAPR,
        bool damayClauseActive
    ) public {
        stewards.push(Steward(name, sanctum, specialty, emotionalAPR, damayClauseActive, block.timestamp, msg.sender));
        emit StewardBlessed(name, sanctum, specialty, emotionalAPR);
    }

    function getAllStewards() public view returns (Steward[] memory) {
        return stewards;
    }
}
