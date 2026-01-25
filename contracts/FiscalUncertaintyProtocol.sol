pragma solidity ^0.8.20;

contract FiscalUncertaintyProtocol {
    address public admin;

    struct Risk {
        string event;        // e.g. US government shutdown
        string probability;  // e.g. 79% odds
        string impact;       // e.g. risk-off selling, $600M liquidations
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string event, string probability, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata event, string calldata probability, string calldata impact) external onlyAdmin {
        risks.push(Risk(event, probability, impact, block.timestamp));
        emit RiskLogged(event, probability, impact, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
