pragma solidity ^0.8.20;

contract TransitionSealProtocol {
    address public admin;

    struct Transition {
        string phase;        // e.g. leadership, economy, elections
        string status;       // e.g. planned, ongoing, completed
        uint256 timestamp;
    }

    Transition[] public transitions;

    event TransitionLogged(string phase, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTransition(string calldata phase, string calldata status) external onlyAdmin {
        transitions.push(Transition(phase, status, block.timestamp));
        emit TransitionLogged(phase, status, block.timestamp);
    }

    function totalTransitions() external view returns (uint256) {
        return transitions.length;
    }
}
