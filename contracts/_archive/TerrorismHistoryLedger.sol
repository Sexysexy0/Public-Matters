pragma solidity ^0.8.0;

contract TerrorismHistoryLedger {
    event HistoryEntry(string incident, string year);

    function logIncident(string memory incident, string memory year) public {
        emit HistoryEntry(incident, year);
    }
}
