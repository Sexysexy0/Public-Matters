// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title RogueMarketDenial.sol
/// @dev Denies market access to flagged nations deploying destabilizing reroute tactics

contract RogueMarketDenial {
    address public steward;

    struct NationStatus {
        string country;
        bool isFlagged;
        string rerouteLog;
        uint256 opacityIndex; // 0–1000 scale
        string lore;
        bool isDenied;
    }

    mapping(bytes32 => NationStatus) public nations;
    bytes32[] public flaggedList;

    event NationFlagged(bytes32 indexed nationId, string country, string rerouteLog);
    event MarketAccessDenied(bytes32 indexed nationId, string lore);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Flag a nation for rogue tactics
    function flagNation(
        bytes32 nationId,
        string memory country,
        string memory rerouteLog,
        uint256 opacityIndex,
        string memory lore
    ) public onlySteward {
        nations[nationId] = NationStatus({
            country: country,
            isFlagged: true,
            rerouteLog: rerouteLog,
            opacityIndex: opacityIndex,
            lore: lore,
            isDenied: false
        });

        flaggedList.push(nationId);
        emit NationFlagged(nationId, country, rerouteLog);
    }

    /// @notice Deny market access if opacity index exceeds threshold
    function denyMarketAccess(bytes32 nationId) public onlySteward {
        require(nations[nationId].isFlagged, "Nation not flagged");
        require(nations[nationId].opacityIndex >= 850, "Opacity threshold not met");
        nations[nationId].isDenied = true;
        emit MarketAccessDenied(nationId, nations[nationId].lore);
    }

    /// @notice Retrieve nation status
    function getNationStatus(bytes32 nationId) public view returns (NationStatus memory) {
        return nations[nationId];
    }

    /// @notice List all flagged nations
    function listFlaggedNations() public view returns (bytes32[] memory) {
        return flaggedList;
    }
}
