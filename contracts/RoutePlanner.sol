// contracts/RoutePlanner.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RoutePlanner
 * @notice Registry of alternative routes and park-and-ride hubs.
 */
contract RoutePlanner {
    struct Route {
        string name;
        string description;
        uint256 capacity;
        bool active;
    }

    Route[] public routes;
    address public owner;

    event RouteAdded(uint256 indexed id, string name, uint256 capacity);
    event RouteStatusChanged(uint256 indexed id, bool active);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addRoute(string calldata name, string calldata description, uint256 capacity) external onlyOwner {
        routes.push(Route(name, description, capacity, true));
        emit RouteAdded(routes.length - 1, name, capacity);
    }

    function setRouteStatus(uint256 id, bool active) external onlyOwner {
        require(id < routes.length, "Invalid route id");
        routes[id].active = active;
        emit RouteStatusChanged(id, active);
    }

    function totalRoutes() external view returns (uint256) {
        return routes.length;
    }

    function getRoute(uint256 id) external view returns (Route memory) {
        require(id < routes.length, "Invalid route id");
        return routes[id];
    }
}
