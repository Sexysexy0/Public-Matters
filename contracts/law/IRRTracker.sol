// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract IRRTracker {
    struct IRRStatus {
        string lawTitle;           // e.g. "RA 12009 – New Government Procurement Act"
        string lawNumber;          // e.g. "RA 12009"
        string issuingAgency;      // e.g. "GPPB", "DOLE", "DBM"
        bool isPublished;
        string irrLink;            // IPFS or external reference
        string emotionalTag;       // e.g. "AuditGlow", "GhostPing", "DamayClause"
        uint256 timestamp;
    }

    IRRStatus[] public irrLogs;

    event IRRLogged(string lawTitle, string lawNumber, bool isPublished, string emotionalTag);

    function logIRR(
        string memory _lawTitle,
        string memory _lawNumber,
        string memory _issuingAgency,
        bool _isPublished,
        string memory _irrLink,
        string memory _emotionalTag
    ) public {
        irrLogs.push(IRRStatus(_lawTitle, _lawNumber, _issuingAgency, _isPublished, _irrLink, _emotionalTag, block.timestamp));
        emit IRRLogged(_lawTitle, _lawNumber, _isPublished, _emotionalTag);
    }

    function getIRR(uint256 index) public view returns (IRRStatus memory) {
        return irrLogs[index];
    }

    function totalIRRs() public view returns (uint256) {
        return irrLogs.length;
    }
}
