// contracts/MaritimeCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MaritimeCommons
 * @notice Logs communal maritime routes and equity in ocean access.
 */
contract MaritimeCommons {
    address public admin;

    struct Route {
        string name;        // "IndianOceanCorridor", "SouthChinaSeaLane"
        string description;
        string status;      // "Open", "Restricted"
        uint256 timestamp;
    }

    Route[] public routes;

    event RouteLogged(string name, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRoute(string calldata name, string calldata description, string calldata status) external onlyAdmin {
        routes.push(Route(name, description, status, block.timestamp));
        emit RouteLogged(name, description, status, block.timestamp);
    }

    function totalRoutes() external view returns (uint256) { return routes.length; }

    function getRoute(uint256 id) external view returns (Route memory) {
        require(id < routes.length, "Invalid id");
        return routes[id];
    }
}
