// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumBlessingProtocol {
    struct Sanctum {
        string name;
        string region;
        string stewardTag; // e.g. "Gueco Clan", "Barangay Guardian"
        uint256 timestamp;
        bool emotionallyTagged;
        bool damayLinked;
        string blessingNotes;
    }

    Sanctum[] public sanctums;
    address public steward;

    event SanctumBlessed(string name, string region, string stewardTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized sanctum caster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blessSanctum(
        string memory _name,
        string memory _region,
        string memory _stewardTag,
        bool _emotionallyTagged,
        bool _damayLinked,
        string memory _blessingNotes
    ) external onlySteward {
        sanctums.push(Sanctum(_name, _region, _stewardTag, block.timestamp, _emotionallyTagged, _damayLinked, _blessingNotes));
        emit SanctumBlessed(_name, _region, _stewardTag);
    }

    function getSanctum(uint256 _id) external view returns (Sanctum memory) {
        return sanctums[_id];
    }

    function totalSanctums() external view returns (uint256) {
        return sanctums.length;
    }
}
