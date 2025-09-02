// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title TourismMasterplanTracker
/// @notice Tracks tourist spot access and sync status with the national tourism masterplan
contract TourismMasterplanTracker {
    address public steward;

    struct Spot {
        string name;
        bool hasDirectFlight;
        bool isMasterplanSynced;
        uint256 upgradeDeadline;
    }

    mapping(string => Spot) public spots;
    string[] public spotList;

    event SpotLogged(string name, bool hasDirectFlight, bool isSynced, uint256 deadline);
    event SyncUpdated(string name, bool isSynced, uint256 newDeadline);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logSpot(string memory name, bool hasDirectFlight, bool isSynced, uint256 deadline) external onlySteward {
        spots[name] = Spot(name, hasDirectFlight, isSynced, deadline);
        spotList.push(name);
        emit SpotLogged(name, hasDirectFlight, isSynced, deadline);
    }

    function updateSyncStatus(string memory name, bool isSynced, uint256 newDeadline) external onlySteward {
        require(bytes(spots[name].name).length > 0, "Spot not registered");
        spots[name].isMasterplanSynced = isSynced;
        spots[name].upgradeDeadline = newDeadline;
        emit SyncUpdated(name, isSynced, newDeadline);
    }

    function getAllSpots() external view returns (string[] memory) {
        return spotList;
    }
}
