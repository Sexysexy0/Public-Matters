pragma solidity ^0.8.20;

contract RegionalAlertProtocol {
    address public admin;

    struct Alert {
        string region;       // e.g. West Philippine Sea
        string trigger;      // e.g. elevated isotope levels
        string response;     // e.g. monitoring, cooperation call
        uint256 timestamp;
    }

    Alert[] public alerts;

    event AlertLogged(string region, string trigger, string response, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAlert(string calldata region, string calldata trigger, string calldata response) external onlyAdmin {
        alerts.push(Alert(region, trigger, response, block.timestamp));
        emit AlertLogged(region, trigger, response, block.timestamp);
    }

    function totalAlerts() external view returns (uint256) {
        return alerts.length;
    }
}
