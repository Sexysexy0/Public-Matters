// SPDX-License-Identifier: ResidencySanctum
pragma solidity ^0.8.19;

contract ResidencyEligibilityRouter {
    struct ResidencySignal {
        address applicant;
        string name;
        string visaType; // e.g., "Investor", "Startup", "Humanitarian"
        bool hasFamily;
        bool housingEligible;
        bool verified;
        string stewardNote;
    }

    mapping(address => ResidencySignal) public residencyRegistry;

    event ResidencyTagged(address applicant, string visaType);
    event EligibilityVerified(address applicant);

    function tagResidency(address applicant, string memory name, string memory visaType, bool hasFamily, bool housingEligible, string memory stewardNote) public {
        residencyRegistry[applicant] = ResidencySignal(applicant, name, visaType, hasFamily, housingEligible, false, stewardNote);
        emit ResidencyTagged(applicant, visaType);
    }

    function verifyEligibility(address applicant) public {
        require(bytes(residencyRegistry[applicant].visaType).length > 0, "Residency not tagged");
        residencyRegistry[applicant].verified = true;
        emit EligibilityVerified(applicant);
    }

    function getResidencyStatus(address applicant) public view returns (ResidencySignal memory) {
        return residencyRegistry[applicant];
    }
}
