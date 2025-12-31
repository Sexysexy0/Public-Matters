// contracts/MirrorCounterProtocol.sol
pragma solidity ^0.8.20;

contract MirrorCounterProtocol {
    address public admin;

    struct Counter {
        string tactic;      // "Spy", "Propaganda", "SeaAggression"
        string mirrored;    // "Expose", "Transparency", "DiplomaticPressure"
        uint256 timestamp;
    }

    Counter[] public counters;

    event CounterLogged(string tactic, string mirrored, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logCounter(string calldata tactic, string calldata mirrored) external onlyAdmin {
        counters.push(Counter(tactic, mirrored, block.timestamp));
        emit CounterLogged(tactic, mirrored, block.timestamp);
    }
}
