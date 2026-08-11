// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EnvironmentalHealthEscrow {
    address public steward;
    mapping(bytes32 => uint256) public assessmentFunds;
    mapping(bytes32 => bool) public auditFailed;

    event FundsDeposited(bytes32 indexed projectId, uint256 amount);
    event AuditFailedReported(bytes32 indexed projectId);
    event FundsConfiscated(bytes32 indexed projectId);

    constructor() {
        steward = msg.sender;
    }

    function depositAssessmentFunds(bytes32 projectId) external payable {
        assessmentFunds[projectId] += msg.value;
        emit FundsDeposited(projectId, msg.value);
    }

    function reportAuditFailure(bytes32 projectId) external {
        auditFailed[projectId] = true;
        emit AuditFailedReported(projectId);
    }

    function confiscateForRemediation(bytes32 projectId, address payable target) external {
        require(msg.sender == steward, "Unauthorized");
        require(auditFailed[projectId], "No audit failure recorded");
        uint256 amount = assessmentFunds[projectId];
        assessmentFunds[projectId] = 0;
        target.transfer(amount);
        emit FundsConfiscated(projectId);
    }

    receive() external payable {}
}
