// SPDX-License-Identifier: SignalSanctum
pragma solidity ^0.8.19;

contract SignalSanctumLedger {
    address public steward;

    struct SignalRecord {
        string broadcastTag; // e.g. "Civic Feed", "News Clip", "Social Post"
        string contentHash;
        string fingerprintStatus; // e.g. "Verified", "Synthetic", "Suspected"
        string originTag; // e.g. "Gov Feed", "AI Generator", "Foreign Source"
        bool sanctified;
        uint256 timestamp;
    }

    SignalRecord[] public records;

    event SignalLogged(string broadcastTag, string contentHash, string fingerprintStatus, string originTag, uint256 timestamp);
    event SignalSanctified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logSignal(
        string memory broadcastTag,
        string memory contentHash,
        string memory fingerprintStatus,
        string memory originTag
    ) public {
        records.push(SignalRecord(broadcastTag, contentHash, fingerprintStatus, originTag, false, block.timestamp));
        emit SignalLogged(broadcastTag, contentHash, fingerprintStatus, originTag, block.timestamp);
    }

    function sanctifySignal(uint256 index) public {
        require(index < records.length, "Invalid index");
        records[index].sanctified = true;
        emit SignalSanctified(index, msg.sender);
    }

    function getSignal(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        SignalRecord memory s = records[index];
        return (s.broadcastTag, s.contentHash, s.fingerprintStatus, s.originTag, s.sanctified, s.timestamp);
    }

    function totalSignals() public view returns (uint256) {
        return records.length;
    }
}
