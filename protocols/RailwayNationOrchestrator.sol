// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RailwayNationOrchestrator: link extensions, costs, terrain, and impacts
contract RailwayNationOrchestrator {
    address public steward;

    address public extensionLedger;
    address public costRegistry;
    address public terrainMirror;
    address public impactGuard;

    event ExpansionEvaluated(
        string route,
        uint256 extensionId,
        uint256 costId,
        uint256 terrainId,
        uint256 impactId,
        string classification
    );

    constructor(
        address _extensionLedger,
        address _costRegistry,
        address _terrainMirror,
        address _impactGuard
    ) {
        steward = msg.sender;
        extensionLedger = _extensionLedger;
        costRegistry = _costRegistry;
        terrainMirror = _terrainMirror;
        impactGuard = _impactGuard;
    }

    function updateContractAddresses(
        address _extensionLedger,
        address _costRegistry,
        address _terrainMirror,
        address _impactGuard
    ) external {
        require(msg.sender == steward, "Only steward");
        extensionLedger = _extensionLedger;
        costRegistry = _costRegistry;
        terrainMirror = _terrainMirror;
        impactGuard = _impactGuard;
    }

    // Evaluate expansion lifecycle by linking IDs from each ledger
    function evaluateExpansion(
        string calldata route,
        uint256 extensionId,
        uint256 costId,
        uint256 terrainId,
        uint256 impactId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (impactId > 0) {
            classification = "Impact Recorded";
        } else if (terrainId > 0) {
            classification = "Terrain Assessed";
        } else if (costId > 0) {
            classification = "Cost Estimated";
        } else if (extensionId > 0) {
            classification = "Extension Proposed";
        } else {
            classification = "No Record";
        }

        emit ExpansionEvaluated(route, extensionId, costId, terrainId, impactId, classification);
    }
}
