// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AccessControlCodex.sol";
import "./DueProcessCodex.sol";
import "./DamayStateMachine.sol";
import "./EmotionalAPR.sol";
import "./SammaCodex.sol";
import "./CivicDAO.sol";
import "./ValidatorRegistry.sol";

/// @title IntegrationRouter
/// @notice Covenant contract to route governance and compliance flows
contract IntegrationRouter {
    AccessControlCodex public access;
    DueProcessCodex public dueProcess;
    DamayStateMachine public damay;
    EmotionalAPR public apr;
    SammaCodex public samma;
    CivicDAO public civic;
    ValidatorRegistry public registry;

    address public sovereignContractor;

    event RouteExecuted(string route, address executor);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor(
        address accessAddr,
        address dueProcessAddr,
        address damayAddr,
        address aprAddr,
        address sammaAddr,
        address civicAddr,
        address registryAddr
    ) {
        access = AccessControlCodex(accessAddr);
        dueProcess = DueProcessCodex(dueProcessAddr);
        damay = DamayStateMachine(damayAddr);
        apr = EmotionalAPR(aprAddr);
        samma = SammaCodex(sammaAddr);
        civic = CivicDAO(civicAddr);
        registry = ValidatorRegistry(registryAddr);
        sovereignContractor = msg.sender;
    }

    function updateAPRAndCheckDamay(
        int256 deltaAPR,
        int256 grief,
        int256 joy,
        int256 anger,
        address actor
    ) external onlyContractor returns (bool) {
        apr.updateAPR(deltaAPR, grief, joy, anger);

        if (apr.currentAPR() < 0) {
            damay.triggerAlert(actor);
        }

        return damay.checkState(actor);
    }

    function executeRoute(string memory _route) public onlyContractor {
        emit RouteExecuted(_route, msg.sender);
    }
}
