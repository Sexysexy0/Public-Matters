// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KFoundryOverrideSuite {
    address public steward;

    struct OverrideRoute {
        string origin;
        string destination;
        bool isActive;
        string fallbackGrid;
        string treatyTag;
    }

    mapping(uint256 => OverrideRoute) public overrideRoutes;
    uint256 public overrideCount;

    event OverrideActivated(uint256 indexed routeId, string origin, string fallbackGrid, string treatyTag);
    event OverrideDeployed(uint256 indexed routeId, string origin, string destination, string fallbackGrid);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function deployOverride(string memory origin, string memory destination, string fallbackGrid, string treatyTag) external onlySteward {
        overrideCount++;
        overrideRoutes[overrideCount] = OverrideRoute(origin, destination, false, fallbackGrid, treatyTag);
        emit OverrideDeployed(overrideCount, origin, destination, fallbackGrid);
    }

    function activateOverride(uint256 routeId) external onlySteward {
        OverrideRoute storage route = overrideRoutes[routeId];
        require(!route.isActive, "Already active");
        route.isActive = true;
        emit OverrideActivated(routeId, route.origin, route.fallbackGrid, route.treatyTag);
    }

    function getOverride(uint256 routeId) external view returns (OverrideRoute memory) {
        return overrideRoutes[routeId];
    }
}
