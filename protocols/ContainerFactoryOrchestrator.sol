// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ContainerFactoryOrchestrator: link factories, modifications, projects, and impacts
contract ContainerFactoryOrchestrator {
    address public steward;

    address public factoryLedger;
    address public modificationRegistry;
    address public projectMirror;
    address public impactGuard;

    event FactoryLifecycleEvaluated(
        string factoryName,
        uint256 factoryId,
        uint256 modificationId,
        uint256 projectId,
        uint256 impactId,
        string classification
    );

    constructor(
        address _factoryLedger,
        address _modificationRegistry,
        address _projectMirror,
        address _impactGuard
    ) {
        steward = msg.sender;
        factoryLedger = _factoryLedger;
        modificationRegistry = _modificationRegistry;
        projectMirror = _projectMirror;
        impactGuard = _impactGuard;
    }

    function updateContractAddresses(
        address _factoryLedger,
        address _modificationRegistry,
        address _projectMirror,
        address _impactGuard
    ) external {
        require(msg.sender == steward, "Only steward");
        factoryLedger = _factoryLedger;
        modificationRegistry = _modificationRegistry;
        projectMirror = _projectMirror;
        impactGuard = _impactGuard;
    }

    // Evaluate lifecycle by linking IDs from each ledger
    function evaluateFactoryLifecycle(
        string calldata factoryName,
        uint256 factoryId,
        uint256 modificationId,
        uint256 projectId,
        uint256 impactId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (impactId > 0) {
            classification = "Impact Recorded";
        } else if (projectId > 0) {
            classification = "Project Deployed";
        } else if (modificationId > 0) {
            classification = "Modification Logged";
        } else if (factoryId > 0) {
            classification = "Factory Registered";
        } else {
            classification = "No Record";
        }

        emit FactoryLifecycleEvaluated(factoryName, factoryId, modificationId, projectId, impactId, classification);
    }
}
