pragma solidity ^0.8.20;

contract EmployeeResilienceProtocol {
    address public admin;

    struct Resilience {
        string initiative;   // e.g. training, wellness, risk management
        string outcome;      // e.g. improved skills, stronger morale
        uint256 timestamp;
    }

    Resilience[] public resilienceLogs;

    event ResilienceLogged(string initiative, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResilience(string calldata initiative, string calldata outcome) external onlyAdmin {
        resilienceLogs.push(Resilience(initiative, outcome, block.timestamp));
        emit ResilienceLogged(initiative, outcome, block.timestamp);
    }

    function totalResilienceLogs() external view returns (uint256) {
        return resilienceLogs.length;
    }
}
