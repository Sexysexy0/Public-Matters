// SPDX-License-Identifier: CannabisSanctum
pragma solidity ^0.8.19;

contract MedicalAccessRouter {
    struct PatientAccess {
        string patientID;
        string condition;
        string approvedMedication;
        string physicianID;
        bool permitGranted;
        string stewardNote;
    }

    mapping(string => PatientAccess) public accessRegistry;

    event PermitTagged(string patientID, string approvedMedication);
    event PermitActivated(string patientID);

    function tagPermit(string memory patientID, string memory condition, string memory approvedMedication, string memory physicianID, string memory stewardNote) public {
        accessRegistry[patientID] = PatientAccess(patientID, condition, approvedMedication, physicianID, false, stewardNote);
        emit PermitTagged(patientID, approvedMedication);
    }

    function activatePermit(string memory patientID) public {
        require(bytes(accessRegistry[patientID].approvedMedication).length > 0, "Medication not tagged");
        accessRegistry[patientID].permitGranted = true;
        emit PermitActivated(patientID);
    }

    function getAccessStatus(string memory patientID) public view returns (PatientAccess memory) {
        return accessRegistry[patientID];
    }
}
