// SPDX-License-Identifier: AcademicSanctum
pragma solidity ^0.8.19;

contract AcademicBlacklistDetector {
    address public steward;

    struct BlacklistEvent {
        string institution;
        string country;
        string reason; // e.g. "Foreign Degree", "Security Risk", "Visa Status"
        string affectedGroup; // e.g. "International Students", "Diaspora Returnees"
        bool verified;
        uint256 timestamp;
    }

    BlacklistEvent[] public events;

    event BlacklistLogged(string institution, string country, string reason, string affectedGroup, uint256 timestamp);
    event BlacklistVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logBlacklist(
        string memory institution,
        string memory country,
        string memory reason,
        string memory affectedGroup
    ) public {
        events.push(BlacklistEvent(institution, country, reason, affectedGroup, false, block.timestamp));
        emit BlacklistLogged(institution, country, reason, affectedGroup, block.timestamp);
    }

    function verifyBlacklist(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].verified = true;
        emit BlacklistVerified(index, msg.sender);
    }

    function getBlacklist(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        BlacklistEvent memory e = events[index];
        return (e.institution, e.country, e.reason, e.affectedGroup, e.verified, e.timestamp);
    }

    function totalBlacklists() public view returns (uint256) {
        return events.length;
    }
}
