pragma solidity ^0.8.20;

contract SystemResilienceCommonsProtocol {
    address public admin;

    struct Metric {
        string category;     // e.g. uptime, patch coverage, incident recovery
        string value;        // e.g. 99.9%, 85%, 2 hours
        uint256 timestamp;
    }

    Metric[] public metrics;

    event MetricLogged(string category, string value, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMetric(string calldata category, string calldata value) external onlyAdmin {
        metrics.push(Metric(category, value, block.timestamp));
        emit MetricLogged(category, value, block.timestamp);
    }

    function totalMetrics() external view returns (uint256) {
        return metrics.length;
    }
}
