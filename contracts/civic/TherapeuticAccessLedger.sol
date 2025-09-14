// SPDX-License-Identifier: MedicinalSanctum
pragma solidity ^0.8.19;

contract TherapeuticAccessLedger {
    struct AccessRecord {
        string stewardName;
        string therapeuticPurpose; // e.g., "medical", "research", "compassionate"
        bool complaintFiled;
        bool underTrial;
        bool inspectionAuthorized;
        bool dignityCertified;
    }

    mapping(address => AccessRecord) public records;

    event AccessLogged(
        address indexed steward,
        string stewardName,
        string therapeuticPurpose,
        bool complaintFiled,
        bool underTrial
    );

    event InspectionAuthorized(address indexed steward);
    event DignityCertified(address indexed steward);

    function logAccess(
        string memory stewardName,
        string memory therapeuticPurpose,
        bool complaintFiled,
        bool underTrial
    ) public {
        records[msg.sender] = AccessRecord(
            stewardName,
            therapeuticPurpose,
            complaintFiled,
            underTrial,
            false,
            false
        );
        emit AccessLogged(msg.sender, stewardName, therapeuticPurpose, complaintFiled, underTrial);
    }

    function authorizeInspection(address steward) public {
        require(
            records[steward].complaintFiled || records[steward].underTrial,
            "Inspection requires formal complaint or active trial"
        );
        records[steward].inspectionAuthorized = true;
        emit InspectionAuthorized(steward);
    }

    function certifyDignity(address steward) public {
        require(
            keccak256(bytes(records[steward].therapeuticPurpose)) != keccak256(bytes("")),
            "Therapeutic purpose must be defined"
        );
        records[steward].dignityCertified = true;
        emit DignityCertified(steward);
    }

    function isAuthorized(address steward) public view returns (bool) {
        return records[steward].inspectionAuthorized;
    }

    function isDignityCertified(address steward) public view returns (bool) {
        return records[steward].dignityCertified;
    }

    function getPurpose(address steward) public view returns (string memory) {
        return records[steward].therapeuticPurpose;
    }
}
