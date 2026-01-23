pragma solidity ^0.8.20;

contract CounterIntelligenceProtocol {
    address public admin;

    struct Counter {
        string threat;       // e.g. espionage, infiltration
        string response;     // e.g. double agent, surveillance neutralization
        string effect;       // e.g. protect secrets, secure networks
        uint256 timestamp;
    }

    Counter[] public counters;

    event CounterLogged(string threat, string response, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCounter(string calldata threat, string calldata response, string calldata effect) external onlyAdmin {
        counters.push(Counter(threat, response, effect, block.timestamp));
        emit CounterLogged(threat, response, effect, block.timestamp);
    }

    function totalCounters() external view returns (uint256) {
        return counters.length;
    }
}
