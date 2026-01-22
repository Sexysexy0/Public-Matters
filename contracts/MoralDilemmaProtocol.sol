pragma solidity ^0.8.20;

contract MoralDilemmaProtocol {
    address public admin;

    struct Dilemma {
        string scenario;     // e.g. Healing on Sabbath
        string question;     // e.g. "Is it lawful to do good or evil?"
        string resolution;   // e.g. silence = agreement, healing justified
        uint256 timestamp;
    }

    Dilemma[] public dilemmas;

    event DilemmaLogged(string scenario, string question, string resolution, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDilemma(string calldata scenario, string calldata question, string calldata resolution) external onlyAdmin {
        dilemmas.push(Dilemma(scenario, question, resolution, block.timestamp));
        emit DilemmaLogged(scenario, question, resolution, block.timestamp);
    }

    function totalDilemmas() external view returns (uint256) {
        return dilemmas.length;
    }
}
