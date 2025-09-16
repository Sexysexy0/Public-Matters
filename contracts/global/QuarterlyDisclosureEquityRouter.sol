// SPDX-License-Identifier: DisclosureSanctum
pragma solidity ^0.8.19;

contract QuarterlyDisclosureEquityRouter {
    struct DisclosureSignal {
        string companyName;
        string cadence; // e.g., "Quarterly", "Semi-Annual"
        string distortionRisk; // e.g., "Short-Termism", "Earnings Manipulation"
        bool verified;
        string stewardNote;
    }

    mapping(string => DisclosureSignal) public disclosureRegistry;

    event CompanyTagged(string companyName, string cadence);
    event RiskVerified(string companyName);

    function tagCompany(string memory companyName, string memory cadence, string memory distortionRisk, string memory stewardNote) public {
        disclosureRegistry[companyName] = DisclosureSignal(companyName, cadence, distortionRisk, false, stewardNote);
        emit CompanyTagged(companyName, cadence);
    }

    function verifyRisk(string memory companyName) public {
        require(bytes(disclosureRegistry[companyName].cadence).length > 0, "Company not tagged");
        disclosureRegistry[companyName].verified = true;
        emit RiskVerified(companyName);
    }

    function getDisclosureStatus(string memory companyName) public view returns (DisclosureSignal memory) {
        return disclosureRegistry[companyName];
    }
}
