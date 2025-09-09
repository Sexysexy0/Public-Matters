// SPDX-License-Identifier: SemiconductorAuditOracle-License
pragma solidity ^0.8.0;

contract SemiconductorAccessAuditOracle {
    address public steward;

    struct AccessAudit {
        string actor;
        string chipType;
        bool passedAudit;
        string reformTriggered;
        uint256 timestamp;
    }

    AccessAudit[] public audits;

    event AccessAuditEmitted(string actor, string chip, bool passed, string reform, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitAudit(string memory actor, string memory chipType, bool passedAudit, string memory reformTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        audits.push(AccessAudit(actor, chipType, passedAudit, reformTriggered, block.timestamp));
        emit AccessAuditEmitted(actor, chipType, passedAudit, reformTriggered, block.timestamp);
    }

    function getAudit(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        AccessAudit memory a = audits[index];
        return (a.actor, a.chipType, a.passedAudit, a.reformTriggered, a.timestamp);
    }
}
