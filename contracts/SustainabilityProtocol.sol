pragma solidity ^0.8.20;

contract SustainabilityProtocol {
    address public admin;

    struct Sustainability {
        string initiative;   // e.g. carbon neutrality, recycling
        string scope;        // e.g. EU, global
        string impact;       // e.g. emissions reduction, consumer trust
        uint256 timestamp;
    }

    Sustainability[] public initiatives;

    event SustainabilityLogged(string initiative, string scope, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSustainability(string calldata initiative, string calldata scope, string calldata impact) external onlyAdmin {
        initiatives.push(Sustainability(initiative, scope, impact, block.timestamp));
        emit SustainabilityLogged(initiative, scope, impact, block.timestamp);
    }

    function totalInitiatives() external view returns (uint256) {
        return initiatives.length;
    }
}
