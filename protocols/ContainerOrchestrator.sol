// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ContainerOrchestrator: link surplus, resell, upcycle, and sustainability records
contract ContainerOrchestrator {
    address public steward;

    address public surplusLedger;
    address public resellRegistry;
    address public upcycleMirror;
    address public sustainabilityGuard;

    event LifecycleEvaluated(
        string containerSize,
        uint256 surplusId,
        uint256 saleId,
        uint256 projectId,
        uint256 measureId,
        string classification
    );

    constructor(
        address _surplusLedger,
        address _resellRegistry,
        address _upcycleMirror,
        address _sustainabilityGuard
    ) {
        steward = msg.sender;
        surplusLedger = _surplusLedger;
        resellRegistry = _resellRegistry;
        upcycleMirror = _upcycleMirror;
        sustainabilityGuard = _sustainabilityGuard;
    }

    function updateContractAddresses(
        address _surplusLedger,
        address _resellRegistry,
        address _upcycleMirror,
        address _sustainabilityGuard
    ) external {
        require(msg.sender == steward, "Only steward");
        surplusLedger = _surplusLedger;
        resellRegistry = _resellRegistry;
        upcycleMirror = _upcycleMirror;
        sustainabilityGuard = _sustainabilityGuard;
    }

    // Evaluate lifecycle by linking IDs from each ledger
    function evaluateLifecycle(
        string calldata containerSize,
        uint256 surplusId,
        uint256 saleId,
        uint256 projectId,
        uint256 measureId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (measureId > 0) {
            classification = "Sustainable";
        } else if (projectId > 0) {
            classification = "Upcycled";
        } else if (saleId > 0) {
            classification = "Resold";
        } else if (surplusId > 0) {
            classification = "Surplus Logged";
        } else {
            classification = "No Record";
        }

        emit LifecycleEvaluated(containerSize, surplusId, saleId, projectId, measureId, classification);
    }
}
