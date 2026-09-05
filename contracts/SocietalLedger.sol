// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SocietalLedger {
    uint256 public prisonCapacity;
    uint256 public educationReformVotes;
    uint256 public polarizationAlerts;

    event PrisonCapacityUpdated(uint256 capacity);
    event EducationReformVoted(uint256 totalVotes);
    event PolarizationAlert(uint256 totalAlerts);

    function updatePrisonCapacity(uint256 capacity) external {
        prisonCapacity = capacity;
        emit PrisonCapacityUpdated(capacity);
    }

    function voteEducationReform() external {
        educationReformVotes++;
        emit EducationReformVoted(educationReformVotes);
    }

    function triggerPolarizationAlert() external {
        polarizationAlerts++;
        emit PolarizationAlert(polarizationAlerts);
    }
}
