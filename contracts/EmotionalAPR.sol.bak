// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./DamayStateMachine.sol";

contract EmotionalAPR {
    int256 public currentAPR;
    DamayStateMachine public damay;

    constructor(address damayAddress) {
        currentAPR = 0;
        damay = DamayStateMachine(damayAddress);
    }

    function updateAPR(
        int256 deltaAPR,
        int256 grief,
        int256 joy,
        int256 anger
    ) public {
        currentAPR += deltaAPR + grief - joy + anger;

        if (currentAPR < 0) {
            damay.triggerAlert(msg.sender);
        }
    }
}
