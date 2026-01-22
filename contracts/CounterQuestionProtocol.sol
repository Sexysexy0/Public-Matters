pragma solidity ^0.8.20;

contract CounterQuestionProtocol {
    address public admin;

    struct Counter {
        string opponent;     // e.g. Pharisees
        string question;     // e.g. "By what authority do you act?"
        string counter;      // e.g. "Was John’s baptism from heaven or men?"
        string outcome;      // e.g. opponent silence, no-win situation
        uint256 timestamp;
    }

    Counter[] public counters;

    event CounterLogged(string opponent, string question, string counter, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCounter(string calldata opponent, string calldata question, string calldata counter, string calldata outcome) external onlyAdmin {
        counters.push(Counter(opponent, question, counter, outcome, block.timestamp));
        emit CounterLogged(opponent, question, counter, outcome, block.timestamp);
    }

    function totalCounters() external view returns (uint256) {
        return counters.length;
    }
}
