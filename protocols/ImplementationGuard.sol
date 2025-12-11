// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ImplementationGuard: block "expiry due to inaction" via readiness checks
contract ImplementationGuard {
    address public steward;

    // readiness signals
    mapping(bytes32 => bool) public okBudget;     // keccak256(project) -> budget ready
    mapping(bytes32 => bool) public okMilestones; // keccak256(project) -> milestones aligned
    mapping(bytes32 => bool) public okAudits;     // keccak256(project) -> audits verified

    mapping(bytes32 => bool) public goSignal;     // final GO to implement

    event ReadySet(bytes32 indexed projectKey, bool budget, bool milestones, bool audits);
    event Go(bytes32 indexed projectKey);

    constructor() { steward = msg.sender; }

    function setReady(bytes32 projectKey, bool budget, bool milestones, bool audits) external {
        require(msg.sender == steward, "Only steward");
        okBudget[projectKey] = budget;
        okMilestones[projectKey] = milestones;
        okAudits[projectKey] = audits;
        emit ReadySet(projectKey, budget, milestones, audits);
    }

    function triggerGo(bytes32 projectKey) external {
        require(msg.sender == steward, "Only steward");
        require(okBudget[projectKey] && okMilestones[projectKey] && okAudits[projectKey], "Not ready");
        goSignal[projectKey] = true;
        emit Go(projectKey);
    }
}
