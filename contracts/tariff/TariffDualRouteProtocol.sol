// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TariffDualRouteProtocol {
    address public steward;
    mapping(address => bool) public sanctionedEntities;
    uint256 public penaltyTariff = 30; // 30% for sanctioned
    uint256 public standardTariff = 5; // 5% for open access

    event TradeAttempt(address indexed trader, string route, uint256 tariffApplied, bool allowed);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function updateSanction(address entity, bool status) external onlySteward {
        sanctionedEntities[entity] = status;
    }

    function sanctionedRoute(address trader) external returns (uint256) {
        require(sanctionedEntities[trader], "Entity not sanctioned");
        emit TradeAttempt(trader, "sanctionedRoute", penaltyTariff, false);
        revert("Trade blocked: sanctioned entity");
    }

    function openAccessRoute(address trader) external returns (uint256) {
        emit TradeAttempt(trader, "openAccessRoute", standardTariff, true);
        return standardTariff;
    }

    function getTariff(address trader) external view returns (uint256) {
        if (sanctionedEntities[trader]) {
            return penaltyTariff;
        }
        return standardTariff;
    }
}
