// SPDX-License-Identifier: StablecoinSanctum
pragma solidity ^0.8.19;

contract StablecoinGovernanceRouter {
    struct GovernanceSignal {
        string issuerName;
        string jurisdiction;
        string reserveType;
        bool verifiedCompliant;
        string stewardNote;
    }

    mapping(string => GovernanceSignal) public governanceRegistry;

    event IssuerTagged(string issuerName, string jurisdiction);
    event ComplianceVerified(string issuerName);

    function tagIssuer(string memory issuerName, string memory jurisdiction, string memory reserveType, string memory stewardNote) public {
        governanceRegistry[issuerName] = GovernanceSignal(issuerName, jurisdiction, reserveType, false, stewardNote);
        emit IssuerTagged(issuerName, jurisdiction);
    }

    function verifyCompliance(string memory issuerName) public {
        require(bytes(governanceRegistry[issuerName].jurisdiction).length > 0, "Issuer not tagged");
        governanceRegistry[issuerName].verifiedCompliant = true;
        emit ComplianceVerified(issuerName);
    }

    function getIssuerStatus(string memory issuerName) public view returns (GovernanceSignal memory) {
        return governanceRegistry[issuerName];
    }
}
