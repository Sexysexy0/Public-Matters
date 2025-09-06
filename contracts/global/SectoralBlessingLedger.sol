// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SectoralBlessingLedger {
    address public steward;

    struct SectorBlessing {
        string sector;
        string sanctum;
        bool emotionallyAligned;
        bool laborEnhancing;
        bool blessingGranted;
        uint256 timestamp;
    }

    SectorBlessing[] public blessings;

    event BlessingGranted(string sector, string sanctum, uint256 timestamp);
    event BlessingRevoked(string sector, string sanctum, string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function grantBlessing(string memory sector, string memory sanctum, bool emotionallyAligned, bool laborEnhancing) external onlySteward {
        require(emotionallyAligned && laborEnhancing, "Blessing criteria not met");
        blessings.push(SectorBlessing(sector, sanctum, emotionallyAligned, laborEnhancing, true, block.timestamp));
        emit BlessingGranted(sector, sanctum, block.timestamp);
    }

    function revokeBlessing(uint256 index, string memory reason) external onlySteward {
        require(index < blessings.length, "Invalid index");
        blessings[index].blessingGranted = false;
        emit BlessingRevoked(blessings[index].sector, blessings[index].sanctum, reason, block.timestamp);
    }

    function getBlessing(uint256 index) external view returns (SectorBlessing memory) {
        require(index < blessings.length, "Index out of bounds");
        return blessings[index];
    }

    function totalBlessings() external view returns (uint256) {
        return blessings.length;
    }
}
