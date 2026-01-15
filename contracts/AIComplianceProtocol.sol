pragma solidity ^0.8.20;

contract AIComplianceProtocol {
    address public admin;

    struct Compliance {
        string rule;         // e.g. safety, privacy, fairness
        string status;       // e.g. enforced, pending, violated
        uint256 timestamp;
    }

    Compliance[] public compliances;

    event ComplianceLogged(string rule, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCompliance(string calldata rule, string calldata status) external onlyAdmin {
        compliances.push(Compliance(rule, status, block.timestamp));
        emit ComplianceLogged(rule, status, block.timestamp);
    }

    function totalCompliances() external view returns (uint256) {
        return compliances.length;
    }
}
