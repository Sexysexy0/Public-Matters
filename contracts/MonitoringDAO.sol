// MonitoringDAO.sol
pragma solidity ^0.8.0;

contract MonitoringDAO {
    struct Alert {
        uint256 id;
        string module;   // e.g. "API Gateway"
        string detail;   // e.g. "High latency detected"
        bool resolved;
    }

    uint256 public alertCount;
    mapping(uint256 => Alert) public alerts;

    event AlertLogged(uint256 id, string module, string detail);
    event AlertResolved(uint256 id, string module);

    function logAlert(string memory module, string memory detail) public {
        alertCount++;
        alerts[alertCount] = Alert(alertCount, module, detail, false);
        emit AlertLogged(alertCount, module, detail);
    }

    function resolveAlert(uint256 id) public {
        alerts[id].resolved = true;
        emit AlertResolved(id, alerts[id].module);
    }
}
