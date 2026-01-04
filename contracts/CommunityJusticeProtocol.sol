pragma solidity ^0.8.20;

contract CommunityJusticeProtocol {
    address public admin;

    struct Petition {
        string issue;
        uint256 votes;
        uint256 timestamp;
    }

    Petition[] public petitions;

    event PetitionLogged(string issue, uint256 votes, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPetition(string calldata issue, uint256 votes) external onlyAdmin {
        petitions.push(Petition(issue, votes, block.timestamp));
        emit PetitionLogged(issue, votes, block.timestamp);
    }

    function totalPetitions() external view returns (uint256) {
        return petitions.length;
    }
}
