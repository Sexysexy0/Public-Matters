// SPDX-License-Identifier: GlobalLicenseAudit-License
pragma solidity ^0.8.0;

contract GlobalLicenseAuditOracle {
    address public steward;

    struct LicenseAudit {
        string actor;
        string chipType;
        bool passedAudit;
        string rippleZone;
        string reformTriggered;
        uint256 timestamp;
    }

    LicenseAudit[] public audits;

    event LicenseAuditEmitted(string actor, string chip, bool passed, string zone, string reform, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitAudit(string memory actor, string memory chipType, bool passedAudit, string memory rippleZone, string memory reformTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        audits.push(LicenseAudit(actor, chipType, passedAudit, rippleZone, reformTriggered, block.timestamp));
        emit LicenseAuditEmitted(actor, chipType, passedAudit, rippleZone, reformTriggered, block.timestamp);
    }

    function getAudit(uint index) public view returns (string memory, string memory, bool, string memory, string memory, uint256) {
        LicenseAudit memory a = audits[index];
        return (a.actor, a.chipType, a.passedAudit, a.rippleZone, a.reformTriggered, a.timestamp);
    }
}
