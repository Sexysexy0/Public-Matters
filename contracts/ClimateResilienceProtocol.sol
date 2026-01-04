pragma solidity ^0.8.20;

contract ClimateResilienceProtocol {
    address public admin;

    struct Initiative {
        string project;     // e.g. flood control, renewable energy
        string impact;      // e.g. reduced emissions, disaster preparedness
        uint256 timestamp;
    }

    Initiative[] public initiatives;

    event InitiativeLogged(string project, string impact, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logInitiative(string calldata project, string calldata impact) external onlyAdmin {
        initiatives.push(Initiative(project, impact, block.timestamp));
        emit InitiativeLogged(project, impact, block.timestamp);
    }

    function totalInitiatives() external view returns (uint256) {
        return initiatives.length;
    }
}
