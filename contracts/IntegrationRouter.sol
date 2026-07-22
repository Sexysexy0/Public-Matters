// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AccessControlCodex.sol";
import "./DueProcessCodex.sol";
import "./DamayStateMachine.sol";
import "./EmotionalAPR.sol";
import "./SammaCodex.sol";
import "./CivicDAO.sol";
import "./ValidatorRegistry.sol";

contract IntegrationRouter {
    AccessControlCodex public access;
    DueProcessCodex public dueProcess;
    DamayStateMachine public damay;
    EmotionalAPR public apr;
    SammaCodex public samma;
    CivicDAO public civic;
    ValidatorRegistry public registry;

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
    }

    /// ✅ Unified function para i-update APR at i-check Damay state
    function updateAPRAndCheckDamay(
        int256 deltaAPR,
        int256 grief,
        int256 joy,
        int256 anger,
        address actor
    ) external returns (bool) {
        // Update APR
        apr.updateAPR(deltaAPR, grief, joy, anger);

        // Ensure router also updates Damay state if APR < 0
        if (apr.currentAPR() < 0) {
            damay.triggerAlert(actor);
        }

        return damay.checkState(actor);
    }
}
