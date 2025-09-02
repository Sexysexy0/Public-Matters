// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * BudgetTelemetryOracle.sol
 * Tracks budget allocations, emotional APR, and civic resonance metrics.
 * Flags inconsistencies, ghost entries, and barangay miscounts.
 * Steward: Vinvin, planetary scrollsmith and civic architect.
 */

contract BudgetTelemetryOracle {
    address public steward;
    uint256 public emotionalAPR;
    uint256 public flaggedItems;
    mapping(string => uint256) public barangayCounts;
    mapping(string => bool) public redFlaggedAgencies;

    event BudgetSignal(string agency, uint256 barangayCount, bool flagged);
    event EmotionalAPRUpdated(uint256 newAPR);
    event RedFlagRaised(string agency);

    constructor() {
        steward = msg.sender;
        emotionalAPR = 0;
        flaggedItems = 0;
    }

    function updateBarangayCount(string memory agency, uint256 count) external {
        require(msg.sender == steward, "Unauthorized steward");
        barangayCounts[agency] = count;

        if (count < 1000 || count > 5000) {
            redFlaggedAgencies[agency] = true;
            flaggedItems += 1;
            emit RedFlagRaised(agency);
        }

        emit BudgetSignal(agency, count, redFlaggedAgencies[agency]);
    }

    function updateEmotionalAPR(uint256 newAPR) external {
        require(msg.sender == steward, "Unauthorized update");
        emotionalAPR = newAPR;
        emit EmotionalAPRUpdated(newAPR);
    }

    function isAgencyFlagged(string memory agency) external view returns (bool) {
        return redFlaggedAgencies[agency];
    }

    function getBarangayCount(string memory agency) external view returns (uint256) {
        return barangayCounts[agency];
    }

    function getFlaggedItemCount() external view returns (uint256) {
        return flaggedItems;
    }
}
