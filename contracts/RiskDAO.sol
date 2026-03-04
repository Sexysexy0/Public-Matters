// RiskDAO.sol
pragma solidity ^0.8.0;

contract RiskDAO {
    struct Risk {
        uint256 id;
        string module;   // e.g. "Payment Gateway"
        string detail;   // e.g. "Potential fraud risk"
        bool mitigated;
    }

    uint256 public riskCount;
    mapping(uint256 => Risk) public risks;

    event RiskLogged(uint256 id, string module, string detail);
    event RiskMitigated(uint256 id, string module);

    function logRisk(string memory module, string memory detail) public {
        riskCount++;
        risks[riskCount] = Risk(riskCount, module, detail, false);
        emit RiskLogged(riskCount, module, detail);
    }

    function mitigateRisk(uint256 id) public {
        risks[id].mitigated = true;
        emit RiskMitigated(id, risks[id].module);
    }
}
