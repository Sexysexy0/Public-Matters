// contracts/SpendingAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SpendingAudit
 * @notice Tracks audits of government spending for communal transparency.
 */
contract SpendingAudit {
    address public admin;

    struct Audit {
        string project;     // "RoadRepair", "SchoolFunding"
        uint256 amount;
        string result;      // "Clean", "Irregularities"
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string project, uint256 amount, string result, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAudit(string calldata project, uint256 amount, string calldata result) external onlyAdmin {
        audits.push(Audit(project, amount, result, block.timestamp));
        emit AuditLogged(project, amount, result, block.timestamp);
    }

    function totalAudits() external view returns (uint256) { return audits.length; }

    function getAudit(uint256 id) external view returns (Audit memory) {
        require(id < audits.length, "Invalid id");
        return audits[id];
    }
}
