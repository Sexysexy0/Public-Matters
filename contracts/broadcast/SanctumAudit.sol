// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumAudit {
    struct AuditEntry {
        uint256 sanctumId;
        bool emotionallyTagged;
        bool damayLinked;
        bool blessingVerified;
        string auditorNotes;
        uint256 timestamp;
    }

    AuditEntry[] public audits;
    address public auditor;

    event SanctumAudited(uint256 sanctumId, bool emotionallyTagged, bool damayLinked, bool blessingVerified);

    modifier onlyAuditor() {
        require(msg.sender == auditor, "Unauthorized sanctum auditor");
        _;
    }

    constructor() {
        auditor = msg.sender;
    }

    function logAudit(
        uint256 _sanctumId,
        bool _emotionallyTagged,
        bool _damayLinked,
        bool _blessingVerified,
        string memory _auditorNotes
    ) external onlyAuditor {
        audits.push(AuditEntry(_sanctumId, _emotionallyTagged, _damayLinked, _blessingVerified, _auditorNotes, block.timestamp));
        emit SanctumAudited(_sanctumId, _emotionallyTagged, _damayLinked, _blessingVerified);
    }

    function getAudit(uint256 _id) external view returns (AuditEntry memory) {
        return audits[_id];
    }

    function totalAudits() external view returns (uint256) {
        return audits.length;
    }
}
