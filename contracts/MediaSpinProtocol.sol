pragma solidity ^0.8.20;

contract MediaSpinProtocol {
    address public admin;

    struct Spin {
        string event;        // e.g. staged rescue, cover-up
        string method;       // e.g. PR manipulation, propaganda
        string outcome;      // e.g. maintained innocence, public trust
        uint256 timestamp;
    }

    Spin[] public spins;

    event SpinLogged(string event, string method, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSpin(string calldata event, string calldata method, string calldata outcome) external onlyAdmin {
        spins.push(Spin(event, method, outcome, block.timestamp));
        emit SpinLogged(event, method, outcome, block.timestamp);
    }

    function totalSpins() external view returns (uint256) {
        return spins.length;
    }
}
