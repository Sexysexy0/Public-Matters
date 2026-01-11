pragma solidity ^0.8.20;

contract FederationCounterProtocol {
    address public admin;

    struct Counter {
        string federation;   // e.g. bureaucracy, monopoly, opacity
        string action;       // e.g. neutralized, resisted, bypassed
        uint256 timestamp;
    }

    Counter[] public counters;

    event CounterLogged(string federation, string action, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCounter(string calldata federation, string calldata action) external onlyAdmin {
        counters.push(Counter(federation, action, block.timestamp));
        emit CounterLogged(federation, action, block.timestamp);
    }

    function totalCounters() external view returns (uint256) {
        return counters.length;
    }
}
