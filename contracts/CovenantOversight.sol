// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Oversight
/// @notice Meta-supervision contract for monitoring enforcement actions
contract CovenantOversight {
    address public guardian;
    uint256 public auditCount;

    struct Audit {
        uint256 id;
        address enforcementContract;
        uint256 caseId;
        string observation;
        bool flagged;
    }

    mapping(uint256 => Audit) public audits;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event AuditLogged(uint256 indexed id, address enforcementContract, uint256 caseId, string observation, bool flagged);

    constructor() {
        guardian = msg.sender;
        auditCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑log ng audit observation sa enforcement case
    function logAudit(address enforcementContract, uint256 caseId, string calldata observation, bool flagged) external onlyGuardian {
        auditCount++;
        audits[auditCount] = Audit(auditCount, enforcementContract, caseId, observation, flagged);
        emit AuditLogged(auditCount, enforcementContract, caseId, observation, flagged);
    }

    /// @notice Tingnan ang audit details
    function viewAudit(uint256 id) external view returns (Audit memory) {
        return audits[id];
    }
}
