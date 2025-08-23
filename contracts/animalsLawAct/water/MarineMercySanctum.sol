// SPDX-License-Identifier: Marine-Mercy-License  
pragma solidity ^0.8.19;

contract MarineMercySanctum {
    struct Patient {
        string species;
        string name;
        string condition;
        bool treated;
        bool emotionalAPRLogged;
    }

    struct Vessel {
        string name;
        string region;
        bool active;
        uint totalPatients;
    }

    Patient[] public patientLog;
    Vessel public mercyVessel;

    event PatientLogged(string species, string name, string condition);
    event TreatmentCompleted(string name);
    event EmotionalAPRLogged(string name);
    event VesselActivated(string name, string region);

    function activateVessel(string memory name, string memory region) public {
        mercyVessel = Vessel(name, region, true, 0);
        emit VesselActivated(name, region);
    }

    function logPatient(
        string memory species,
        string memory name,
        string memory condition,
        bool emotionalAPRLogged
    ) public {
        patientLog.push(Patient(species, name, condition, false, emotionalAPRLogged));
        mercyVessel.totalPatients += 1;
        emit PatientLogged(species, name, condition);
        if (emotionalAPRLogged) emit EmotionalAPRLogged(name);
    }

    function completeTreatment(uint index) public {
        require(index < patientLog.length, "Invalid index");
        patientLog[index].treated = true;
        emit TreatmentCompleted(patientLog[index].name);
    }

    function getPatient(uint index) public view returns (Patient memory) {
        require(index < patientLog.length, "Invalid index");
        return patientLog[index];
    }
}
