// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ImplementationGuard: ensure projects don't expire due to inaction
contract ImplementationGuard {
    struct Status {
        bool budgetReady;
        bool designReady;
        bool auditReady;
        bool goSignal;
    }

    mapping(bytes32 => Status) public projectStatus;
    address public steward;

    event StatusUpdated(bytes32 indexed projectKey, bool budget, bool design, bool audit);
    event Go(bytes32 indexed projectKey);

    constructor() { steward = msg.sender; }

    function setStatus(bytes32 projectKey, bool budget, bool design, bool audit) external {
        require(msg.sender == steward, "Only steward");
        projectStatus[projectKey].budgetReady = budget;
        projectStatus[projectKey].designReady = design;
        projectStatus[projectKey].auditReady = audit;
        emit StatusUpdated(projectKey, budget, design, audit);
    }

    function triggerGo(bytes32 projectKey) external {
        require(msg.sender == steward, "Only steward");
        Status storage s = projectStatus[projectKey];
        require(s.budgetReady && s.designReady && s.auditReady, "Not ready");
        s.goSignal = true;
        emit Go(projectKey);
    }
}
