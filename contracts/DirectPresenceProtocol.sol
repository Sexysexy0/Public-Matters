pragma solidity ^0.8.20;

contract DirectPresenceProtocol {
    address public presence;

    struct Entry {
        string event;        // e.g. meeting, deployment, communal audit
        uint256 timestamp;
    }

    Entry[] public entries;

    event PresenceLogged(string event, uint256 timestamp);

    constructor() { presence = msg.sender; }

    modifier onlyPresence() { require(msg.sender == presence, "Not presence"); _; }

    function logPresence(string calldata event) external onlyPresence {
        entries.push(Entry(event, block.timestamp));
        emit PresenceLogged(event, block.timestamp);
    }

    function totalEntries() external view returns (uint256) {
        return entries.length;
    }
}
