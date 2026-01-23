pragma solidity ^0.8.20;

contract EmployerComplianceProtocol {
    address public admin;

    struct Compliance {
        string company;      // e.g. employer name
        string requirement;  // e.g. NCR wage applied in Bulacan
        string status;       // e.g. compliant, non-compliant
        uint256 timestamp;
    }

    Compliance[] public compliances;

    event ComplianceLogged(string company, string requirement, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCompliance(string calldata company, string calldata requirement, string calldata status) external onlyAdmin {
        compliances.push(Compliance(company, requirement, status, block.timestamp));
        emit ComplianceLogged(company, requirement, status, block.timestamp);
    }

    function totalCompliances() external view returns (uint256) {
        return compliances.length;
    }
}
