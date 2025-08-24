// SPDX-License-Identifier: Scrollchain-Audit
pragma solidity ^0.8.19;

contract GlobalPowerAuditTrail {
    address public steward;

    struct AuditEntry {
        string nation;
        string action;
        string timestamp;
        string emotionalAPRNote;
    }

    AuditEntry[] public entries;

    event AuditLogged(string nation, string action, string timestamp, string emotionalAPRNote);

    constructor() {
        steward = msg.sender;
    }

    function logAudit(string memory nation, string memory action, string memory timestamp, string memory emotionalAPRNote) public {
        require(msg.sender == steward, "Unauthorized steward");
        entries.push(AuditEntry(nation, action, timestamp, emotionalAPRNote));
        emit AuditLogged(nation, action, timestamp, emotionalAPRNote);
    }

    function getAudit(uint id) public view returns (AuditEntry memory) {
        require(id < entries.length, "Invalid audit ID");
        return entries[id];
    }

    function totalAudits() public view returns (uint) {
        return entries.length;
    }
}
