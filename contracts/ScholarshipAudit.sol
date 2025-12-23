// contracts/ScholarshipAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ScholarshipAudit
 * @notice Tracks scholarships and communal equity in educational support.
 */
contract ScholarshipAudit {
    address public admin;

    struct Scholarship {
        string beneficiary;
        string program;
        uint256 amount;
        string status;   // "Granted", "Pending"
        uint256 timestamp;
    }

    Scholarship[] public scholarships;

    event ScholarshipLogged(string beneficiary, string program, uint256 amount, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logScholarship(string calldata beneficiary, string calldata program, uint256 amount, string calldata status) external onlyAdmin {
        scholarships.push(Scholarship(beneficiary, program, amount, status, block.timestamp));
        emit ScholarshipLogged(beneficiary, program, amount, status, block.timestamp);
    }

    function totalScholarships() external view returns (uint256) { return scholarships.length; }

    function getScholarship(uint256 id) external view returns (Scholarship memory) {
        require(id < scholarships.length, "Invalid id");
        return scholarships[id];
    }
}
