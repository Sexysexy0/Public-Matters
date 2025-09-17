// SPDX-License-Identifier: ConstitutionalSanctum
pragma solidity ^0.8.19;

contract FirstAmendmentBlessingRouter {
    address public steward;

    struct SpeechRecord {
        string speaker;
        string statement;
        string contextTag; // e.g. "Hate Speech Policy", "Political Threat", "Legal Enforcement"
        bool constitutionallyAligned;
        uint256 timestamp;
    }

    SpeechRecord[] public records;

    event SpeechLogged(string speaker, string statement, string contextTag, uint256 timestamp);
    event BlessingVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logSpeech(
        string memory speaker,
        string memory statement,
        string memory contextTag
    ) public {
        records.push(SpeechRecord(speaker, statement, contextTag, false, block.timestamp));
        emit SpeechLogged(speaker, statement, contextTag, block.timestamp);
    }

    function verifyBlessing(uint256 index) public {
        require(index < records.length, "Invalid index");
        records[index].constitutionallyAligned = true;
        emit BlessingVerified(index, msg.sender);
    }

    function getSpeech(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        SpeechRecord memory s = records[index];
        return (s.speaker, s.statement, s.contextTag, s.constitutionallyAligned, s.timestamp);
    }

    function totalSpeechRecords() public view returns (uint256) {
        return records.length;
    }
}
