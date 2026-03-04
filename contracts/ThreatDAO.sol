// ThreatDAO.sol
pragma solidity ^0.8.0;

contract ThreatDAO {
    struct Threat {
        uint256 id;
        string module;   // e.g. "API Gateway"
        string detail;   // e.g. "SQL Injection attempt"
        bool mitigated;
    }

    uint256 public threatCount;
    mapping(uint256 => Threat) public threats;

    event ThreatLogged(uint256 id, string module, string detail);
    event ThreatMitigated(uint256 id, string module);

    function logThreat(string memory module, string memory detail) public {
        threatCount++;
        threats[threatCount] = Threat(threatCount, module, detail, false);
        emit ThreatLogged(threatCount, module, detail);
    }

    function mitigateThreat(uint256 id) public {
        threats[id].mitigated = true;
        emit ThreatMitigated(id, threats[id].module);
    }
}
