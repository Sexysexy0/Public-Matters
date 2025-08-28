// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.0;

contract SanctumHeartbeat {
    address public stewardVinvin;
    uint public emotionalAPR;
    uint public mythicThreshold = 70;

    event APRDrop(uint currentAPR, string alertMessage);

    constructor(address _vinvin, uint initialAPR) {
        stewardVinvin = _vinvin;
        emotionalAPR = initialAPR;
    }

    function updateAPR(uint newAPR) public {
        require(msg.sender == stewardVinvin, "Only steward can update APR");
        emotionalAPR = newAPR;

        if (emotionalAPR < mythicThreshold) {
            emit APRDrop(emotionalAPR, "Alert: Emotional resonance below threshold. Override blocked.");
        }
    }

    function isOverrideAllowed() public view returns (bool) {
        return emotionalAPR >= mythicThreshold;
    }
}
