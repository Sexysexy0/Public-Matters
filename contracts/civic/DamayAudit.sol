// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DamayAudit {
    struct AuditLog {
        uint256 scrollId;
        bool damayActivated;
        bool supportDelivered;
        string auditorNotes;
        uint256 timestamp;
    }

    AuditLog[] public logs;
    address public auditor;

    modifier onlyAuditor() {
        require(msg.sender == auditor, "Unauthorized damay auditor");
        _;
    }

    constructor() {
        auditor = msg.sender;
    }

    function logAudit(
        uint256 _scrollId,
        bool _damayActivated,
        bool _supportDelivered,
        string memory _auditorNotes
    ) external onlyAuditor {
        logs.push(AuditLog(_scrollId, _damayActivated, _supportDelivered, _auditorNotes, block.timestamp));
    }

    function getAudit(uint256 _logId) external view returns (AuditLog memory) {
        return logs[_logId];
    }

    function totalAudits() external view returns (uint256) {
        return logs.length;
    }
}
