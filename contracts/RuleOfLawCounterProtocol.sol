pragma solidity ^0.8.20;

contract RuleOfLawCounterProtocol {
    address public admin;

    struct Counter {
        string actor;        // e.g. Macron
        string principle;    // e.g. respect vs bullying, rule of law vs brutality
        string contrast;     // e.g. European values vs America First
        uint256 timestamp;
    }

    Counter[] public counters;

    event CounterLogged(string actor, string principle, string contrast, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCounter(string calldata actor, string calldata principle, string calldata contrast) external onlyAdmin {
        counters.push(Counter(actor, principle, contrast, block.timestamp));
        emit CounterLogged(actor, principle, contrast, block.timestamp);
    }

    function totalCounters() external view returns (uint256) {
        return counters.length;
    }
}
