// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChipResilienceRouter {
    address public steward;

    struct ChipRoute {
        string origin;
        string destination;
        bool isSanctioned;
        bool overrideEnabled;
        string fallbackGrid;
    }

    mapping(uint256 => ChipRoute) public routes;
    uint256 public routeCount;

    event RouteDeployed(uint256 indexed routeId, string origin, string destination, bool overrideEnabled);
    event FallbackActivated(uint256 indexed routeId, string fallbackGrid);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function deployRoute(string memory origin, string memory destination, bool isSanctioned, string memory fallbackGrid) external onlySteward {
        routeCount++;
        routes[routeCount] = ChipRoute(origin, destination, isSanctioned, isSanctioned, fallbackGrid);
        emit RouteDeployed(routeCount, origin, destination, isSanctioned);
    }

    function activateFallback(uint256 routeId) external onlySteward {
        ChipRoute storage route = routes[routeId];
        require(route.overrideEnabled, "Override not enabled");
        emit FallbackActivated(routeId, route.fallbackGrid);
    }

    function getRoute(uint256 routeId) external view returns (ChipRoute memory) {
        return routes[routeId];
    }
}
