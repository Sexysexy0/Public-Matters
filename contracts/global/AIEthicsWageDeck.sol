// SPDX-License-Identifier: AIEthicsSanctum
pragma solidity ^0.8.19;

contract AIEthicsWageDeck {
    address public steward;

    struct AuditLog {
        string systemName;
        bool biasDetected;
        string notes;
        uint256 timestamp;
    }

    AuditLog[] public logs;

    event AuditLogged(string systemName, bool biasDetected, string notes, uint256 timestamp);

    function logAudit(string memory systemName, bool biasDetected, string memory notes) public {
        require(msg.sender == steward, "Only steward may log audits");
        logs.push(AuditLog(systemName, biasDetected, notes, block.timestamp));
        emit AuditLogged(systemName, biasDetected, notes, block.timestamp);
    }

    function getAudit(uint256 index) public view returns (string memory, bool, string memory, uint256) {
        AuditLog memory log = logs[index];
        return (log.systemName, log.biasDetected, log.notes, log.timestamp);
    }
}
