pragma solidity ^0.8.20;

contract HistoricDifficultyProtocol {
    address public admin;

    struct Difficulty {
        string feature;      // e.g. consistent high-effort reasoning
        string challenge;    // e.g. hard to invent in fiction
        string implication;  // e.g. suggests authenticity of Gospels
        uint256 timestamp;
    }

    Difficulty[] public difficulties;

    event DifficultyLogged(string feature, string challenge, string implication, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDifficulty(string calldata feature, string calldata challenge, string calldata implication) external onlyAdmin {
        difficulties.push(Difficulty(feature, challenge, implication, block.timestamp));
        emit DifficultyLogged(feature, challenge, implication, block.timestamp);
    }

    function totalDifficulties() external view returns (uint256) {
        return difficulties.length;
    }
}
