// SPDX-License-Identifier: StrategicSanctum
pragma solidity ^0.8.19;

contract DefensePactRenewalRouter {
    struct PactSignal {
        address countryID;
        string countryName;
        string partnerName; // e.g., "United States"
        string pactType; // e.g., "Enhanced Defense Cooperation"
        bool renewalConfirmed;
        string stewardNote;
    }

    mapping(address => PactSignal) public pactRegistry;

    event PactTagged(address countryID, string pactType);
    event RenewalConfirmed(address countryID);

    function tagPact(
        address countryID,
        string memory countryName,
        string memory partnerName,
        string memory pactType,
        bool renewalConfirmed,
        string memory stewardNote
    ) public {
        pactRegistry[countryID] = PactSignal(
            countryID,
            countryName,
            partnerName,
            pactType,
            renewalConfirmed,
            stewardNote
        );
        emit PactTagged(countryID, pactType);
    }

    function confirmRenewal(address countryID) public {
        require(bytes(pactRegistry[countryID].countryName).length > 0, "Pact not tagged");
        pactRegistry[countryID].renewalConfirmed = true;
        emit RenewalConfirmed(countryID);
    }

    function getPactStatus(address countryID) public view returns (PactSignal memory) {
        return pactRegistry[countryID];
    }
}
