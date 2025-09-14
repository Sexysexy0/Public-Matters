// SPDX-License-Identifier: MedicinalSanctum
pragma solidity ^0.8.19;

contract TherapeuticRestorationSuite {
    struct TherapeuticUse {
        string stewardName;
        string purpose; // e.g., "medical", "research", "compassionate"
        bool complaintFiled;
        bool underTrial;
        bool inspectionAuthorized;
    }

    mapping(address => TherapeuticUse) public registry;

    event UseLogged(address indexed steward, string stewardName, string purpose, bool complaintFiled, bool underTrial);
    event InspectionAuthorized(address indexed steward);

    function logUse(
        string memory stewardName,
        string memory purpose,
        bool complaintFiled,
        bool underTrial
    ) public {
        registry[msg.sender] = TherapeuticUse(stewardName, purpose, complaintFiled, underTrial, false);
        emit UseLogged(msg.sender, stewardName, purpose, complaintFiled, underTrial);
    }

    function authorizeInspection(address steward) public {
        require(
            registry[steward].complaintFiled || registry[steward].underTrial,
            "Inspection requires formal complaint or active trial"
        );
        registry[steward].inspectionAuthorized = true;
        emit InspectionAuthorized(steward);
    }

    function isAuthorized(address steward) public view returns (bool) {
        return registry[steward].inspectionAuthorized;
    }

    function getPurpose(address steward) public view returns (string memory) {
        return registry[steward].purpose;
    }
}
