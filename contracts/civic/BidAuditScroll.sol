// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract BidAuditScroll {
    address public steward;

    struct AuditLog {
        string contractor;
        uint256 bidAmount;
        string emotionalTag;
        bool damayClauseIncluded;
        bool rogueIntentDetected;
        uint256 timestamp;
    }

    AuditLog[] public logs;

    event AuditLogged(string contractor, uint256 bidAmount, string emotionalTag, bool damayClauseIncluded, bool rogueIntentDetected);

    constructor() {
        steward = msg.sender;
    }

    function logBidAudit(
        string memory contractor,
        uint256 bidAmount,
        string memory emotionalTag,
        bool damayClauseIncluded,
        bool rogueIntentDetected
    ) public {
        logs.push(AuditLog(contractor, bidAmount, emotionalTag, damayClauseIncluded, rogueIntentDetected, block.timestamp));
        emit AuditLogged(contractor, bidAmount, emotionalTag, damayClauseIncluded, rogueIntentDetected);
    }

    function getAuditLog(uint256 index) public view returns (AuditLog memory) {
        return logs[index];
    }

    function totalLogs() public view returns (uint256) {
        return logs.length;
    }
}
