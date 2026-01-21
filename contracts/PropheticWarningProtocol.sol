pragma solidity ^0.8.20;

contract PropheticWarningProtocol {
    address public admin;

    struct Warning {
        string message;      // e.g. recession, persecution, flood of filth
        string urgency;      // e.g. prepare financially, guard faith, resist deception
        uint256 timestamp;
    }

    Warning[] public warnings;

    event WarningLogged(string message, string urgency, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWarning(string calldata message, string calldata urgency) external onlyAdmin {
        warnings.push(Warning(message, urgency, block.timestamp));
        emit WarningLogged(message, urgency, block.timestamp);
    }

    function totalWarnings() external view returns (uint256) {
        return warnings.length;
    }
}
