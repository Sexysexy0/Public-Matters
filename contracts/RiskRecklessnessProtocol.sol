pragma solidity ^0.8.20;

contract RiskRecklessnessProtocol {
    address public admin;

    struct Risk {
        string agency;       // e.g. Mossad
        string tactic;       // e.g. high-risk targeted operation
        string consequence;  // e.g. backlash, global opinion shift
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string agency, string tactic, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata agency, string calldata tactic, string calldata consequence) external onlyAdmin {
        risks.push(Risk(agency, tactic, consequence, block.timestamp));
        emit RiskLogged(agency, tactic, consequence, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
