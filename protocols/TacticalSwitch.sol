// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TacticalSwitch
 * @dev Allows for instantaneous shifting between different Sovereign personas.
 */
contract TacticalSwitch {
    enum Persona { Engineer, Father, Comptroller }
    Persona public activePersona;

    // [Goal: Achieve maximum tactical flexibility across all life-missions]
    function switchRole(Persona _newPersona) external {
        activePersona = _newPersona;
    }
}

