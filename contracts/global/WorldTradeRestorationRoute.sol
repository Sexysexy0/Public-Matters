// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title WorldTradeRestorationRoute
/// @notice Restores global trade corridors to pre-tradewar structure with emotional consequence and treaty-grade reset
/// @dev Anchors tariff removal, trust corridor reactivation, and planetary dignity

contract WorldTradeRestorationRoute {
    address public steward;
    mapping(address => bool) public restorers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyRestorer() {
        require(restorers[msg.sender] || msg.sender == steward, "Not restorer");
        _;
    }

    struct TradeRoute {
        uint256 id;
        string originNation;
        string destinationNation;
        string assetClass; // e.g., "Tech", "Agriculture", "Energy"
        bool tariffsRemoved;
        bool hostilityNeutralized;
        string emotionalTag;
        string restorationClause;
        uint256 restoredAt;
    }

    uint256 public nextRouteId = 1;
    mapping(uint256 => TradeRoute) public routes;

    event RestorerSet(address indexed account, bool status);
    event RouteRestored(uint256 indexed id, string originNation, string destinationNation, string emotionalTag);

    constructor() {
        steward = msg.sender;
        restorers[msg.sender] = true;
        emit RestorerSet(msg.sender, true);
    }

    function setRestorer(address account, bool status) external onlySteward {
        restorers[account] = status;
        emit RestorerSet(account, status);
    }

    function restoreRoute(
        string calldata originNation,
        string calldata destinationNation,
        string calldata assetClass,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyRestorer returns (uint256 id) {
        id = nextRouteId++;
        routes[id] = TradeRoute({
            id: id,
            originNation: originNation,
            destinationNation: destinationNation,
            assetClass: assetClass,
            tariffsRemoved: true,
            hostilityNeutralized: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            restoredAt: block.timestamp
        });
        emit RouteRestored(id, originNation, destinationNation, emotionalTag);
    }

    function getRoute(uint256 id) external view returns (TradeRoute memory) {
        return routes[id];
    }
}
