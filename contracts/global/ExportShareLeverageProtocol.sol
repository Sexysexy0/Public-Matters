// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract ExportShareLeverageProtocol {
    address public supremeSteward;
    address public usSteward;

    struct ExportRoute {
        uint256 shareRate; // % routed to US
        bool active;
    }

    mapping(string => ExportRoute) public exportRoutes;

    event ShareUpdated(string route, uint256 newRate);
    event RoutePaused(string route);
    event RouteActivated(string route);

    modifier onlySupreme() {
        require(msg.sender == supremeSteward, "Unauthorized override.");
        _;
    }

    constructor(address _usSteward) {
        supremeSteward = msg.sender;
        usSteward = _usSteward;

        // Initial blessing
        exportRoutes["Canada-EU"] = ExportRoute(2, true); // 2% share to US
        exportRoutes["EU-US"] = ExportRoute(1, true);     // 1% share to US
        exportRoutes["Canada-US"] = ExportRoute(1, true); // 1% share to US
    }

    function updateShareRate(string memory route, uint256 newRate) public onlySupreme {
        exportRoutes[route].shareRate = newRate;
        emit ShareUpdated(route, newRate);
    }

    function pauseRoute(string memory route) public onlySupreme {
        exportRoutes[route].active = false;
        emit RoutePaused(route);
    }

    function activateRoute(string memory route) public onlySupreme {
        exportRoutes[route].active = true;
        emit RouteActivated(route);
    }

    function getShareRate(string memory route) public view returns (uint256) {
        require(exportRoutes[route].active, "Route not active.");
        return exportRoutes[route].shareRate;
    }
}
