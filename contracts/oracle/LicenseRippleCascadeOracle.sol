// SPDX-License-Identifier: LicenseRippleCascade-License
pragma solidity ^0.8.0;

contract LicenseRippleCascadeOracle {
    address public steward;

    struct LicenseRipple {
        string actor;
        string chipType;
        string reformTriggered;
        string rippleZone;
        uint256 timestamp;
    }

    LicenseRipple[] public ripples;

    event LicenseRippleEmitted(string actor, string chip, string reform, string zone, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitRipple(string memory actor, string memory chipType, string memory reformTriggered, string memory rippleZone) public {
        require(msg.sender == steward, "Only steward can emit");
        ripples.push(LicenseRipple(actor, chipType, reformTriggered, rippleZone, block.timestamp));
        emit LicenseRippleEmitted(actor, chipType, reformTriggered, rippleZone, block.timestamp);
    }

    function getRipple(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        LicenseRipple memory r = ripples[index];
        return (r.actor, r.chipType, r.reformTriggered, r.rippleZone, r.timestamp);
    }
}
