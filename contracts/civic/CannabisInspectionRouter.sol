// SPDX-License-Identifier: MedicinalSanctum
pragma solidity ^0.8.19;

contract CannabisInspectionRouter {
    struct UseCase {
        bool complaintFiled;
        bool underTrial;
        bool inspectionAuthorized;
        string purpose; // e.g., "medical", "research", "personal"
    }

    mapping(address => UseCase) public registry;

    event UseCaseLogged(address indexed steward, string purpose, bool complaintFiled, bool underTrial);
    event InspectionAuthorized(address indexed steward);

    function logUseCase(string memory purpose, bool complaintFiled, bool underTrial) public {
        registry[msg.sender] = UseCase(complaintFiled, underTrial, false, purpose);
        emit UseCaseLogged(msg.sender, purpose, complaintFiled, underTrial);
    }

    function authorizeInspection(address steward) public {
        require(
            registry[steward].complaintFiled || registry[steward].underTrial,
            "Inspection requires complaint or active trial"
        );
        registry[steward].inspectionAuthorized = true;
        emit InspectionAuthorized(steward);
    }

    function isAuthorized(address steward) public view returns (bool) {
        return registry[steward].inspectionAuthorized;
    }
}
