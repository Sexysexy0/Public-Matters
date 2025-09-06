// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FusionBadgeMintingProtocol {
    address public steward;

    struct FusionBadge {
        string aiSystem;
        string humanSteward;
        string sector;
        uint256 emotionalAPR;
        uint256 dignityScore;
        bool badgeMinted;
        uint256 timestamp;
    }

    FusionBadge[] public badges;

    event BadgeMinted(string aiSystem, string humanSteward, string sector, uint256 emotionalAPR, uint256 dignityScore, uint256 timestamp);
    event BadgeRevoked(string aiSystem, string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function mintBadge(
        string memory aiSystem,
        string memory humanSteward,
        string memory sector,
        uint256 emotionalAPR,
        uint256 dignityScore
    ) external onlySteward {
        require(emotionalAPR >= 70 && dignityScore >= 60, "Fusion criteria not met");
        badges.push(FusionBadge(aiSystem, humanSteward, sector, emotionalAPR, dignityScore, true, block.timestamp));
        emit BadgeMinted(aiSystem, humanSteward, sector, emotionalAPR, dignityScore, block.timestamp);
    }

    function revokeBadge(uint256 index, string memory reason) external onlySteward {
        require(index < badges.length, "Invalid index");
        badges[index].badgeMinted = false;
        emit BadgeRevoked(badges[index].aiSystem, reason, block.timestamp);
    }

    function getBadge(uint256 index) external view returns (FusionBadge memory) {
        require(index < badges.length, "Index out of bounds");
        return badges[index];
    }

    function totalBadges() external view returns (uint256) {
        return badges.length;
    }
}
