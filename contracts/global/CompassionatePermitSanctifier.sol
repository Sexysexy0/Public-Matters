// SPDX-License-Identifier: CompassionSanctum
pragma solidity ^0.8.19;

contract CompassionatePermitSanctifier {
    struct Permit {
        string patientID;
        string condition;
        string medication;
        string physicianID;
        bool isApproved;
        uint256 expiryDate;
        string stewardNote;
    }

    mapping(string => Permit) public permits;

    event PermitIssued(string patientID, string medication);
    event PermitRenewed(string patientID);

    function issuePermit(string memory patientID, string memory condition, string memory medication, string memory physicianID, uint256 expiryDate, string memory stewardNote) public {
        permits[patientID] = Permit(patientID, condition, medication, physicianID, true, expiryDate, stewardNote);
        emit PermitIssued(patientID, medication);
    }

    function renewPermit(string memory patientID, uint256 newExpiryDate) public {
        require(permits[patientID].isApproved, "Permit not active");
        permits[patientID].expiryDate = newExpiryDate;
        emit PermitRenewed(patientID);
    }

    function getPermitStatus(string memory patientID) public view returns (Permit memory) {
        return permits[patientID];
    }
}
