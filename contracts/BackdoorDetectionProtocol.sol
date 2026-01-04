pragma solidity ^0.8.20;

contract BackdoorDetectionProtocol {
    address public admin;

    struct Backdoor {
        string name;         // e.g. TONESHELL, rootkit loader
        string vector;       // e.g. kernel driver, phishing, supply chain
        string status;       // e.g. detected, mitigated, removed
        uint256 timestamp;
    }

    Backdoor[] public backdoors;

    event BackdoorLogged(string name, string vector, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logBackdoor(string calldata name, string calldata vector, string calldata status) external onlyAdmin {
        backdoors.push(Backdoor(name, vector, status, block.timestamp));
        emit BackdoorLogged(name, vector, status, block.timestamp);
    }

    function totalBackdoors() external view returns (uint256) {
        return backdoors.length;
    }
}
