// SPDX-License-Identifier: HealingCorridorSanctum
pragma solidity ^0.8.19;

contract MentalHealthClinicSanctifier {
    struct Clinic {
        string clinicID;
        string region;
        uint256 cannabisTaxFunded;
        bool operational;
        uint256 patientCapacity;
        string stewardNote;
    }

    mapping(string => Clinic) public clinicRegistry;

    event ClinicTagged(string clinicID, uint256 cannabisTaxFunded);
    event ClinicSanctified(string clinicID);

    function tagClinic(string memory clinicID, string memory region, uint256 cannabisTaxFunded, uint256 patientCapacity, string memory stewardNote) public {
        clinicRegistry[clinicID] = Clinic(clinicID, region, cannabisTaxFunded, false, patientCapacity, stewardNote);
        emit ClinicTagged(clinicID, cannabisTaxFunded);
    }

    function sanctifyClinic(string memory clinicID) public {
        require(clinicRegistry[clinicID].cannabisTaxFunded > 0, "No funding tagged");
        clinicRegistry[clinicID].operational = true;
        emit ClinicSanctified(clinicID);
    }

    function getClinicStatus(string memory clinicID) public view returns (Clinic memory) {
        return clinicRegistry[clinicID];
    }
}
