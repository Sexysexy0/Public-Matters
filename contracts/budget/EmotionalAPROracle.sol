// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EmotionalAPROracle {
    address public steward;

    struct APRTag {
        string sector;
        uint256 empathy;
        uint256 trust;
        uint256 clarity;
        uint256 timestamp;
    }

    APRTag[] public tags;

    event APRTagged(string sector, uint256 empathy, uint256 trust, uint256 clarity);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function tagSector(string memory sector, uint256 empathy, uint256 trust, uint256 clarity) public onlySteward {
        tags.push(APRTag(sector, empathy, trust, clarity, block.timestamp));
        emit APRTagged(sector, empathy, trust, clarity);
    }

    function getTag(uint256 index) public view returns (APRTag memory) {
        require(index < tags.length, "Invalid index");
        return tags[index];
    }

    function totalTags() public view returns (uint256) {
        return tags.length;
    }
}
