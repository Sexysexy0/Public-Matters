// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title TourismAccessLedger
/// @notice Tracks direct flight access to tourist spots and upgrade timelines
contract TourismAccessLedger {
    address public steward;

    struct TouristSpot {
        string name;
        bool hasDirectFlight;
        uint256 estimatedUpgradeDate; // Unix timestamp
    }

    mapping(string => TouristSpot) public spots;
    string[] public spotList;

    event SpotRegistered(string name, bool hasDirectFlight, uint256 upgradeDate);
    event FlightAccessUpdated(string name, bool hasDirectFlight, uint256 newUpgradeDate);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerSpot(string memory name, bool hasDirectFlight, uint256 upgradeDate) external onlySteward {
        spots[name] = TouristSpot(name, hasDirectFlight, upgradeDate);
        spotList.push(name);
        emit SpotRegistered(name, hasDirectFlight, upgradeDate);
    }

    function updateFlightAccess(string memory name, bool hasDirectFlight, uint256 newUpgradeDate) external onlySteward {
        require(bytes(spots[name].name).length > 0, "Spot not registered");
        spots[name].hasDirectFlight = hasDirectFlight;
        spots[name].estimatedUpgradeDate = newUpgradeDate;
        emit FlightAccessUpdated(name, hasDirectFlight, newUpgradeDate);
    }

    function getAllSpots() external view returns (string[] memory) {
        return spotList;
    }
}
