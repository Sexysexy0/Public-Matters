pragma solidity ^0.8.20;

contract TrapAvoidanceProtocol {
    address public admin;

    struct Trap {
        string question;     // e.g. "Should we pay taxes to Caesar?"
        string response;     // e.g. "Render unto Caesar..."
        string outcome;      // e.g. avoided trap, shifted focus
        uint256 timestamp;
    }

    Trap[] public traps;

    event TrapLogged(string question, string response, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTrap(string calldata question, string calldata response, string calldata outcome) external onlyAdmin {
        traps.push(Trap(question, response, outcome, block.timestamp));
        emit TrapLogged(question, response, outcome, block.timestamp);
    }

    function totalTraps() external view returns (uint256) {
        return traps.length;
    }
}
