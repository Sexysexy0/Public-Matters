// SPDX-License-Identifier: CBInnovationSanctum
pragma solidity ^0.8.19;

contract CentralBankInnovationRouter {
    struct InnovationSignal {
        string bankName;
        string projectName;
        string innovationType;
        bool verified;
        string stewardNote;
    }

    mapping(string => InnovationSignal) public innovationRegistry;

    event ProjectTagged(string bankName, string projectName);
    event InnovationVerified(string bankName);

    function tagProject(string memory bankName, string memory projectName, string memory innovationType, string memory stewardNote) public {
        innovationRegistry[bankName] = InnovationSignal(bankName, projectName, innovationType, false, stewardNote);
        emit ProjectTagged(bankName, projectName);
    }

    function verifyInnovation(string memory bankName) public {
        require(bytes(innovationRegistry[bankName].projectName).length > 0, "Project not tagged");
        innovationRegistry[bankName].verified = true;
        emit InnovationVerified(bankName);
    }

    function getInnovationStatus(string memory bankName) public view returns (InnovationSignal memory) {
        return innovationRegistry[bankName];
    }
}
