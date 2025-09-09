// SPDX-License-Identifier: SanctumPulseCascade-License
pragma solidity ^0.8.0;

contract SanctumPulseCascadeOracle {
    address public steward;

    struct PulseCascade {
        string sanctumZone;
        string reformType;
        string rippleEffect;
        uint256 timestamp;
    }

    PulseCascade[] public cascades;

    event PulseCascadeEmitted(string zone, string reform, string ripple, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCascade(string memory sanctumZone, string memory reformType, string memory rippleEffect) public {
        require(msg.sender == steward, "Only steward can emit");
        cascades.push(PulseCascade(sanctumZone, reformType, rippleEffect, block.timestamp));
        emit PulseCascadeEmitted(sanctumZone, reformType, rippleEffect, block.timestamp);
    }

    function getCascade(uint index) public view returns (string memory, string memory, string memory, uint256) {
        PulseCascade memory c = cascades[index];
        return (c.sanctumZone, c.reformType, c.rippleEffect, c.timestamp);
    }
}
