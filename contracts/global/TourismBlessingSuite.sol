// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./TourismMasterplanTracker.sol";
import "./AirportBlessingRegistry.sol";

/// @title TourismBlessingSuite
/// @notice Centralized suite for tracking tourism upgrades, flight access, and emotional APR
contract TourismBlessingSuite {
    address public steward;
    TourismMasterplanTracker public tracker;
    AirportBlessingRegistry public registry;

    event BlessingSynced(string spot, string airport, string region, string aprMood);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address _tracker, address _registry) {
        steward = msg.sender;
        tracker = TourismMasterplanTracker(_tracker);
        registry = AirportBlessingRegistry(_registry);
    }

    /// @notice Syncs a tourist spot with its airport blessing
    function syncBlessing(
        string memory spot,
        string memory airport,
        string memory region,
        string memory upgradeType,
        string memory aprMood,
        uint256 deadline
    ) external onlySteward {
        tracker.updateSyncStatus(spot, true, deadline);
        registry.logBlessing(airport, region, upgradeType, aprMood);
        emit BlessingSynced(spot, airport, region, aprMood);
    }
}
