pragma solidity ^0.8.20;

contract ReasoningDriftProtocol {
    address public admin;

    struct Drift {
        string trigger;      // e.g. delay, ambiguous signal, minor irregularity
        string narrative;    // e.g. catastrophe, collapse, conspiracy
        uint256 timestamp;
    }

    Drift[] public drifts;

    event DriftLogged(string trigger, string narrative, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDrift(string calldata trigger, string calldata narrative) external onlyAdmin {
        drifts.push(Drift(trigger, narrative, block.timestamp));
        emit DriftLogged(trigger, narrative, block.timestamp);
    }

    function totalDrifts() external view returns (uint256) {
        return drifts.length;
    }
}
