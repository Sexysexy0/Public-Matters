// GeopoliticalRiskDAO.sol
pragma solidity ^0.8.0;

contract GeopoliticalRiskDAO {
    struct Risk {
        uint256 id;
        string type;   // e.g. "Cyber", "Tariffs", "Conflict"
        uint256 severity;
        bool mitigated;
    }

    uint256 public riskCount;
    mapping(uint256 => Risk) public risks;

    event RiskLogged(uint256 id, string type, uint256 severity);
    event RiskMitigated(uint256 id, string type);
    event RiskDeclared(string message);

    function logRisk(string memory type, uint256 severity) public {
        riskCount++;
        risks[riskCount] = Risk(riskCount, type, severity, false);
        emit RiskLogged(riskCount, type, severity);
    }

    function mitigateRisk(uint256 id) public {
        Risk storage r = risks[id];
        require(!r.mitigated, "Already mitigated");
        r.mitigated = true;
        emit RiskMitigated(r.id, r.type);
    }

    function declareRisk() public {
        emit RiskDeclared("Geopolitical Risk DAO: communal defense arcs encoded into resilience seals.");
    }
}
