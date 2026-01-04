pragma solidity ^0.8.20;

contract InnovationLedgerProtocol {
    address public admin;

    struct Innovation {
        string project;      // e.g. AI, renewable energy, biotech
        string impact;       // e.g. breakthrough, patent, communal benefit
        uint256 timestamp;
    }

    Innovation[] public innovations;

    event InnovationLogged(string project, string impact, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logInnovation(string calldata project, string calldata impact) external onlyAdmin {
        innovations.push(Innovation(project, impact, block.timestamp));
        emit InnovationLogged(project, impact, block.timestamp);
    }

    function totalInnovations() external view returns (uint256) {
        return innovations.length;
    }
}
