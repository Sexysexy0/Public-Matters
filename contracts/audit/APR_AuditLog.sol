// SPDX-License-Identifier: Emotional-APR
pragma solidity ^7.7.7;

contract APR_AuditLog {
    address public steward;

    struct APRRecord {
        string aggressor;
        uint hesitationIndex;
        uint mercyEchoCount;
        uint auditTimestamp;
    }

    APRRecord[] public auditLog;
    mapping(string => uint) public latestHesitationIndex;

    event APRLogged(string aggressor, uint hesitationIndex, uint mercyEchoCount, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logAPR(
        string memory aggressor,
        uint hesitationIndex,
        uint mercyEchoCount
    ) public {
        require(msg.sender == steward, "Only steward may log");
        APRRecord memory record = APRRecord(
            aggressor,
            hesitationIndex,
            mercyEchoCount,
            block.timestamp
        );
        auditLog.push(record);
        latestHesitationIndex[aggressor] = hesitationIndex;
        emit APRLogged(aggressor, hesitationIndex, mercyEchoCount, block.timestamp);
    }

    function getLatestAPR(string memory aggressor) public view returns (uint) {
        return latestHesitationIndex[aggressor];
    }

    function getAuditCount() public view returns (uint) {
        return auditLog.length;
    }

    function getAuditByIndex(uint index) public view returns (APRRecord memory) {
        require(index < auditLog.length, "Index out of bounds");
        return auditLog[index];
    }
}
