pragma solidity ^0.8.20;

contract HypeCycleProtocol {
    address public admin;

    struct Hype {
        string phase;        // e.g. peak, trough, plateau
        string narrative;    // e.g. AGI dream, toy, sedative
        string effect;       // e.g. investor rush, fatigue
        uint256 timestamp;
    }

    Hype[] public hypes;

    event HypeLogged(string phase, string narrative, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logHype(string calldata phase, string calldata narrative, string calldata effect) external onlyAdmin {
        hypes.push(Hype(phase, narrative, effect, block.timestamp));
        emit HypeLogged(phase, narrative, effect, block.timestamp);
    }

    function totalHypes() external view returns (uint256) {
        return hypes.length;
    }
}
