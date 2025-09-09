// SPDX-License-Identifier: GlobalAnchorAudit-License
pragma solidity ^0.8.0;

contract GlobalAnchorAuditOracle {
    address public steward;

    struct AnchorAudit {
        string currency;
        string anchorType;
        bool anchorConfirmed;
        string auditSource;
        uint256 timestamp;
    }

    AnchorAudit[] public audits;

    event AnchorAuditEmitted(string currency, string anchorType, bool anchorConfirmed, string auditSource, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitAudit(string memory currency, string memory anchorType, bool anchorConfirmed, string memory auditSource) public {
        require(msg.sender == steward, "Only steward can emit");
        audits.push(AnchorAudit(currency, anchorType, anchorConfirmed, auditSource, block.timestamp));
        emit AnchorAuditEmitted(currency, anchorType, anchorConfirmed, auditSource, block.timestamp);
    }

    function getAudit(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        AnchorAudit memory a = audits[index];
        return (a.currency, a.anchorType, a.anchorConfirmed, a.auditSource, a.timestamp);
    }
}
