// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PlanetaryBlessingRegistry {
    address public steward;

    struct Blessing {
        string entity;
        string tag;
        uint256 emotionalAPR;
        string treatyRef;
        uint256 timestamp;
        bool active;
    }

    Blessing[] public blessings;
    mapping(string => bool) public isBlessed;

    event BlessingCommitted(string entity, string tag, uint256 emotionalAPR, string treatyRef);
    event BlessingRevoked(string entity);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function commitBlessing(
        string memory entity,
        string memory tag,
        uint256 emotionalAPR,
        string memory treatyRef
    ) public onlySteward {
        blessings.push(Blessing(entity, tag, emotionalAPR, treatyRef, block.timestamp, true));
        isBlessed[entity] = true;
        emit BlessingCommitted(entity, tag, emotionalAPR, treatyRef);
    }

    function revokeBlessing(string memory entity) public onlySteward {
        isBlessed[entity] = false;
        emit BlessingRevoked(entity);
    }

    function getBlessing(uint256 index) public view returns (
        string memory entity,
        string memory tag,
        uint256 emotionalAPR,
        string memory treatyRef,
        uint256 timestamp,
        bool active
    ) {
        Blessing memory b = blessings[index];
        return (b.entity, b.tag, b.emotionalAPR, b.treatyRef, b.timestamp, b.active);
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
