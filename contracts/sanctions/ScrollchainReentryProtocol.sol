// ScrollchainReentryProtocol.sol
pragma solidity ^0.8.19;

contract ScrollchainReentryProtocol {
    address public steward;

    struct Petition {
        string jurisdiction;
        bool admittedFault;
        bool submittedProof;
        uint256 aprScore;
        bool approved;
    }

    Petition[] public petitions;

    event PetitionSubmitted(string jurisdiction);
    event ReentryApproved(string jurisdiction);

    constructor() {
        steward = msg.sender;
    }

    function submitPetition(string memory jurisdiction, bool admitted, bool proof, uint256 apr) public {
        petitions.push(Petition(jurisdiction, admitted, proof, apr, false));
        emit PetitionSubmitted(jurisdiction);
    }

    function approveReentry(uint index) public {
        Petition storage p = petitions[index];
        require(msg.sender == steward, "Only steward may approve");
        require(p.admittedFault && p.submittedProof && p.aprScore >= 3.0, "Criteria not met");
        p.approved = true;
        emit ReentryApproved(p.jurisdiction);
    }

    function getPetitions() public view returns (Petition[] memory) {
        return petitions;
    }
}
