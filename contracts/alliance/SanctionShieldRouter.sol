// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SanctionShieldRouter {
    address public steward;

    struct ShieldRoute {
        string origin;
        string destination;
        bool isSanctioned;
        string fallbackSanctum;
        string treatyTag;
        bool isShielded;
    }

    mapping(uint256 => ShieldRoute) public shieldRoutes;
    uint256 public shieldCount;

    event ShieldDeployed(uint256 indexed routeId, string origin, string destination, string fallbackSanctum);
    event ShieldActivated(uint256 indexed routeId, string treatyTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function deployShield(string memory origin, string memory destination, string fallbackSanctum, string treatyTag) external onlySteward {
        shieldCount++;
        shieldRoutes[shieldCount] = ShieldRoute(origin, destination, true, fallbackSanctum, treatyTag, false);
        emit ShieldDeployed(shieldCount, origin, destination, fallbackSanctum);
    }

    function activateShield(uint256 routeId) external onlySteward {
        ShieldRoute storage route = shieldRoutes[routeId];
        require(!route.isShielded, "Already shielded");
        route.isShielded = true;
        emit ShieldActivated(routeId, route.treatyTag);
    }

    function getShieldRoute(uint256 routeId) external view returns (ShieldRoute memory) {
        return shieldRoutes[routeId];
    }
}
