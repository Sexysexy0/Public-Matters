// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BarangayCostOfLivingSync
/// @dev Syncs barangay-level cost-of-living estimates and emotional APR telemetry

contract BarangayCostOfLivingSync {
    struct CostProfile {
        uint256 weeklyEstimate;
        uint256 monthlyEstimate;
        string emotionalAPR;
        bool overrideSuggested;
    }

    mapping(string => CostProfile) public barangayProfiles;
    address public steward;

    event CostSynced(string indexed barangay, uint256 monthlyEstimate, string emotionalAPR, bool overrideSuggested);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function syncCost(string memory barangay, uint256 weekly, uint256 monthly, string memory apr, bool overrideFlag) public onlySteward {
        barangayProfiles[barangay] = CostProfile(weekly, monthly, apr, overrideFlag);
        emit CostSynced(barangay, monthly, apr, overrideFlag);
    }

    function getCostProfile(string memory barangay) public view returns (CostProfile memory) {
        return barangayProfiles[barangay];
    }
}
