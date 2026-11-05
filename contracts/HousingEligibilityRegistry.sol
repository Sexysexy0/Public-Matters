// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HousingEligibilityRegistry {
    struct Applicant {
        bool isMinimumWageEarner;
        bool currentlyRenting;
        bool hasFamilyWithChildren;
        bool isRegistered;
    }

    mapping(address => Applicant) public applicants;
    mapping(address => uint256) public approvedMonthlyBudget;

    event ApplicantRegistered(address indexed applicant, uint256 suggestedMonthlyAmortization);
    event EligibilityVerified(address indexed applicant, bool status);

    function registerForHousing(
        bool _isMinimumWageEarner,
        bool _currentlyRenting,
        bool _hasFamilyWithChildren,
        uint256 _suggestedMonthlyAmortization
    ) external {
        require(_isMinimumWageEarner && _currentlyRenting && _hasFamilyWithChildren, "Must meet criteria: minimum wage, renting, with family");
        
        applicants[msg.sender] = Applicant({
            isMinimumWageEarner: _isMinimumWageEarner,
            currentlyRenting: _currentlyRenting,
            hasFamilyWithChildren: _hasFamilyWithChildren,
            isRegistered: true
        });

        approvedMonthlyBudget[msg.sender] = _suggestedMonthlyAmortization;

        emit ApplicantRegistered(msg.sender, _suggestedMonthlyAmortization);
        emit EligibilityVerified(msg.sender, true);
    }
}
