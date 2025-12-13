// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// MotorPartsOrchestrator: link factories, parts, customs, and impacts
contract MotorPartsOrchestrator {
    address public steward;

    address public factoryLedger;
    address public partsRegistry;
    address public customMirror;
    address public impactGuard;

    event LifecycleEvaluated(
        string factoryName,
        uint256 factoryId,
        uint256 partId,
        uint256 customId,
        uint256 impactId,
        string classification
    );

    constructor(
        address _factoryLedger,
        address _partsRegistry,
        address _customMirror,
        address _impactGuard
    ) {
        steward = msg.sender;
        factoryLedger = _factoryLedger;
        partsRegistry = _partsRegistry;
        customMirror = _customMirror;
        impactGuard = _impactGuard;
    }

    function updateContractAddresses(
        address _factoryLedger,
        address _partsRegistry,
        address _customMirror,
        address _impactGuard
    ) external {
        require(msg.sender == steward, "Only steward");
        factoryLedger = _factoryLedger;
        partsRegistry = _partsRegistry;
        customMirror = _customMirror;
        impactGuard = _impactGuard;
    }

    // Evaluate lifecycle by linking IDs from each ledger
    function evaluateLifecycle(
        string calldata factoryName,
        uint256 factoryId,
        uint256 partId,
        uint256 customId,
        uint256 impactId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (impactId > 0) {
            classification = "Impact Recorded";
        } else if (customId > 0) {
            classification = "Customization Logged";
        } else if (partId > 0) {
            classification = "Part Registered";
        } else if (factoryId > 0) {
            classification = "Factory Registered";
        } else {
            classification = "No Record";
        }

        emit LifecycleEvaluated(factoryName, factoryId, partId, customId, impactId, classification);
    }
}
