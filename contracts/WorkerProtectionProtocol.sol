pragma solidity ^0.8.20;

contract WorkerProtectionProtocol {
    address public admin;

    struct Protection {
        string right;        // e.g. equal pay, safe workplace
        string mechanism;    // e.g. grievance system, legal aid
        string outcome;      // e.g. dignity, fairness
        uint256 timestamp;
    }

    Protection[] public protections;

    event ProtectionLogged(string right, string mechanism, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logProtection(string calldata right, string calldata mechanism, string calldata outcome) external onlyAdmin {
        protections.push(Protection(right, mechanism, outcome, block.timestamp));
        emit ProtectionLogged(right, mechanism, outcome, block.timestamp);
    }

    function totalProtections() external view returns (uint256) {
        return protections.length;
    }
}
