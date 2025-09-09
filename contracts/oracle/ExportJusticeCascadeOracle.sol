// SPDX-License-Identifier: ExportJusticeCascade-License
pragma solidity ^0.8.0;

contract ExportJusticeCascadeOracle {
    address public steward;

    struct JusticeCascade {
        string actor;
        string chipType;
        string reformTriggered;
        string rippleZone;
        bool synchronized;
        uint256 timestamp;
    }

    JusticeCascade[] public cascades;

    event JusticeCascadeEmitted(string actor, string chip, string reform, string zone, bool sync, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCascade(string memory actor, string memory chipType, string memory reformTriggered, string memory rippleZone, bool synchronized) public {
        require(msg.sender == steward, "Only steward can emit");
        cascades.push(JusticeCascade(actor, chipType, reformTriggered, rippleZone, synchronized, block.timestamp));
        emit JusticeCascadeEmitted(actor, chipType, reformTriggered, rippleZone, synchronized, block.timestamp);
    }

    function getCascade(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        JusticeCascade memory c = cascades[index];
        return (c.actor, c.chipType, c.reformTriggered, c.rippleZone, c.synchronized, c.timestamp);
    }
}
