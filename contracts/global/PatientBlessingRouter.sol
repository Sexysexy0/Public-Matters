// SPDX-License-Identifier: PatientSanctum
pragma solidity ^0.8.19;

contract PatientBlessingRouter {
    address public steward;

    struct PatientSignal {
        string patientID;
        string condition; // e.g. "Epilepsy", "Cancer", "Chronic Pain"
        string blessingStatus; // "CSP Approved", "Pending", "Denied"
        string physicianTag; // e.g. "Dr. Santos #12"
        bool verified;
        uint256 timestamp;
    }

    PatientSignal[] public signals;

    event PatientLogged(string patientID, string condition, string blessingStatus, string physicianTag, uint256 timestamp);
    event PatientVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logPatient(
        string memory patientID,
        string memory condition,
        string memory blessingStatus,
        string memory physicianTag
    ) public {
        signals.push(PatientSignal(patientID, condition, blessingStatus, physicianTag, false, block.timestamp));
        emit PatientLogged(patientID, condition, blessingStatus, physicianTag, block.timestamp);
    }

    function verifyPatient(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit PatientVerified(index, msg.sender);
    }

    function getPatient(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        PatientSignal memory p = signals[index];
        return (p.patientID, p.condition, p.blessingStatus, p.physicianTag, p.verified, p.timestamp);
    }

    function totalPatientSignals() public view returns (uint256) {
        return signals.length;
    }
}
