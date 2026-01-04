pragma solidity ^0.8.20;

contract BrowserTelemetryProtocol {
    address public admin;

    struct Telemetry {
        string browser;      // e.g. Chrome, Firefox, Edge
        string event;        // e.g. extension install, suspicious activity
        uint256 timestamp;
    }

    Telemetry[] public logs;

    event TelemetryLogged(string browser, string event, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logTelemetry(string calldata browser, string calldata event) external onlyAdmin {
        logs.push(Telemetry(browser, event, block.timestamp));
        emit TelemetryLogged(browser, event, block.timestamp);
    }

    function totalLogs() external view returns (uint256) {
        return logs.length;
    }
}
