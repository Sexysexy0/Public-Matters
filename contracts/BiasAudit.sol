// contracts/BiasAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BiasAudit
 * @notice Tracks audits of media bias and transparency.
 */
contract BiasAudit {
    address public admin;

    struct Audit {
        string outlet;      // "NewspaperX", "TVStationY"
        string bias;        // "Left", "Right", "Neutral"
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string outlet, string bias, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAudit(string calldata outlet, string calldata bias) external onlyAdmin {
        audits.push(Audit(outlet, bias, block.timestamp));
        emit AuditLogged(outlet, bias, block.timestamp);
    }

    function totalAudits() external view returns (uint256) { return audits.length; }

    function getAudit(uint256 id) external view returns (Audit memory) {
        require(id < audits.length, "Invalid id");
        return audits[id];
    }
}
