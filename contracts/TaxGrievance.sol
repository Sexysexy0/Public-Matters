// contracts/TaxGrievance.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TaxGrievance
 * @notice Logs community grievances about property taxes and transparency.
 */
contract TaxGrievance {
    address public admin;

    struct Grievance {
        string issue;       // "HighPropertyTax", "Transparency", "Displacement"
        string description;
        uint256 timestamp;
    }

    Grievance[] public grievances;

    event GrievanceLogged(string issue, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logGrievance(string calldata issue, string calldata description) external onlyAdmin {
        grievances.push(Grievance(issue, description, block.timestamp));
        emit GrievanceLogged(issue, description, block.timestamp);
    }

    function totalGrievances() external view returns (uint256) { return grievances.length; }

    function getGrievance(uint256 id) external view returns (Grievance memory) {
        require(id < grievances.length, "Invalid id");
        return grievances[id];
    }
}
