// SPDX-License-Identifier: ShelterSanctum
pragma solidity ^0.8.19;

contract FamilyShelterRouter {
    struct ShelterSignal {
        address applicant;
        string familyName;
        uint256 householdSize;
        string shelterType; // e.g., "Urban", "Rural", "Transitional", "Permanent"
        bool dignityCertified;
        bool verified;
        string stewardNote;
    }

    mapping(address => ShelterSignal) public shelterRegistry;

    event ShelterTagged(address applicant, string shelterType);
    event ShelterVerified(address applicant);

    function tagShelter(address applicant, string memory familyName, uint256 householdSize, string memory shelterType, bool dignityCertified, string memory stewardNote) public {
        shelterRegistry[applicant] = ShelterSignal(applicant, familyName, householdSize, shelterType, dignityCertified, false, stewardNote);
        emit ShelterTagged(applicant, shelterType);
    }

    function verifyShelter(address applicant) public {
        require(bytes(shelterRegistry[applicant].shelterType).length > 0, "Shelter not tagged");
        shelterRegistry[applicant].verified = true;
        emit ShelterVerified(applicant);
    }

    function getShelterStatus(address applicant) public view returns (ShelterSignal memory) {
        return shelterRegistry[applicant];
    }
}
