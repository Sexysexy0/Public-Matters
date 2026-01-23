pragma solidity ^0.8.20;

contract PriceMonitoringProtocol {
    address public admin;

    struct Monitoring {
        string commodity;    // e.g. diesel, rice, vegetables
        string mechanism;    // e.g. price watch, audit
        string outcome;      // e.g. prevent overpricing, stabilize market
        uint256 timestamp;
    }

    Monitoring[] public monitorings;

    event MonitoringLogged(string commodity, string mechanism, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMonitoring(string calldata commodity, string calldata mechanism, string calldata outcome) external onlyAdmin {
        monitorings.push(Monitoring(commodity, mechanism, outcome, block.timestamp));
        emit MonitoringLogged(commodity, mechanism, outcome, block.timestamp);
    }

    function totalMonitorings() external view returns (uint256) {
        return monitorings.length;
    }
}
