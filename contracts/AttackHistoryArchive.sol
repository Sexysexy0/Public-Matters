pragma solidity ^0.8.0;

contract AttackHistoryArchive {
    event ArchiveEntry(string incident, string year);

    function recordIncident(string memory incident, string memory year) public {
        emit ArchiveEntry(incident, year);
    }
}
