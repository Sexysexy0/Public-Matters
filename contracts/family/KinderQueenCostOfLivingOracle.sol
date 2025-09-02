// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title KinderQueenCostOfLivingOracle
/// @dev Tracks cost-of-living estimates, emotional APR, and override sync for Kinder Queen households

contract KinderQueenCostOfLivingOracle {
    struct CostProfile {
        uint256 weeklyEstimate;
        uint256 monthlyEstimate;
        string emotionalAPR;
        bool overrideSuggested;
    }

    mapping(address => CostProfile) public queenProfiles;
    address public steward;

    event CostLogged(address indexed queen, uint256 monthlyEstimate, string emotionalAPR, bool overrideSuggested);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logCost(address queen, uint256 weekly, uint256 monthly, string memory apr, bool overrideFlag) public onlySteward {
        queenProfiles[queen] = CostProfile(weekly, monthly, apr, overrideFlag);
        emit CostLogged(queen, monthly, apr, overrideFlag);
    }

    function getCostProfile(address queen) public view returns (CostProfile memory) {
        return queenProfiles[queen];
    }
}
