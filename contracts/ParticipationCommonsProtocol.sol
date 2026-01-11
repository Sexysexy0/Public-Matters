pragma solidity ^0.8.20;

contract ParticipationCommonsProtocol {
    address public admin;

    struct Participation {
        string member;       // e.g. stockholder, citizen, validator
        string activity;     // e.g. vote, audit, deployment
        uint256 timestamp;
    }

    Participation[] public participations;

    event ParticipationLogged(string member, string activity, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logParticipation(string calldata member, string calldata activity) external onlyAdmin {
        participations.push(Participation(member, activity, block.timestamp));
        emit ParticipationLogged(member, activity, block.timestamp);
    }

    function totalParticipations() external view returns (uint256) {
        return participations.length;
    }
}
