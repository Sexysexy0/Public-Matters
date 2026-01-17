pragma solidity ^0.8.20;

contract AdversityProtocol {
    address public admin;

    struct Challenge {
        string context;      // e.g. poverty, abusive environment
        string lesson;       // e.g. focus on controllables, meaning in giving
        uint256 timestamp;
    }

    Challenge[] public challenges;

    event ChallengeLogged(string context, string lesson, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logChallenge(string calldata context, string calldata lesson) external onlyAdmin {
        challenges.push(Challenge(context, lesson, block.timestamp));
        emit ChallengeLogged(context, lesson, block.timestamp);
    }

    function totalChallenges() external view returns (uint256) {
        return challenges.length;
    }
}
