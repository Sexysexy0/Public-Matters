// SPDX-License-Identifier: SanctumForgivenessAudit-License
pragma solidity ^0.8.0;

contract SanctumForgivenessAuditRouter {
    address public steward;

    struct ForgivenessAudit {
        string actorID;
        string offenseType;
        string sanctumID;
        bool restorationConfirmed;
        string emotionalAPR;
        uint256 timestamp;
    }

    ForgivenessAudit[] public audits;

    event ForgivenessAuditRouted(string actorID, string offenseType, string sanctumID, bool restorationConfirmed, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeAudit(string memory actorID, string memory offenseType, string memory sanctumID, bool restorationConfirmed, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        audits.push(ForgivenessAudit(actorID, offenseType, sanctumID, restorationConfirmed, emotionalAPR, block.timestamp));
        emit ForgivenessAuditRouted(actorID, offenseType, sanctumID, restorationConfirmed, emotionalAPR, block.timestamp);
    }

    function getAudit(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        ForgivenessAudit memory a = audits[index];
        return (a.actorID, a.offenseType, a.sanctumID, a.restorationConfirmed, a.emotionalAPR, a.timestamp);
    }
}
