pragma solidity ^0.8.20;

contract ConfidenceLoopProtocol {
    address public admin;

    struct Loop {
        string trigger;      // e.g. contradiction, irregularity
        string reinforcement; // e.g. certainty escalation, narrative patch
        uint256 timestamp;
    }

    Loop[] public loops;

    event LoopLogged(string trigger, string reinforcement, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLoop(string calldata trigger, string calldata reinforcement) external onlyAdmin {
        loops.push(Loop(trigger, reinforcement, block.timestamp));
        emit LoopLogged(trigger, reinforcement, block.timestamp);
    }

    function totalLoops() external view returns (uint256) {
        return loops.length;
    }
}
