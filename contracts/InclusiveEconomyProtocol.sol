pragma solidity ^0.8.20;

contract InclusiveEconomyProtocol {
    address public admin;

    struct Initiative {
        string project;      // e.g. housing, skills training, small business financing
        string outcome;      // e.g. inclusive growth, opportunity expansion
        uint256 timestamp;
    }

    Initiative[] public initiatives;

    event InitiativeLogged(string project, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInitiative(string calldata project, string calldata outcome) external onlyAdmin {
        initiatives.push(Initiative(project, outcome, block.timestamp));
        emit InitiativeLogged(project, outcome, block.timestamp);
    }

    function totalInitiatives() external view returns (uint256) {
        return initiatives.length;
    }
}
