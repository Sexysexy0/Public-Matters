pragma solidity ^0.8.20;

contract AuthenticitySignalProtocol {
    address public admin;

    struct Signal {
        string feature;      // e.g. consistent high-effort reasoning
        string implication;  // e.g. difficult to invent, suggests historicity
        uint256 timestamp;
    }

    Signal[] public signals;

    event SignalLogged(string feature, string implication, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSignal(string calldata feature, string calldata implication) external onlyAdmin {
        signals.push(Signal(feature, implication, block.timestamp));
        emit SignalLogged(feature, implication, block.timestamp);
    }

    function totalSignals() external view returns (uint256) {
        return signals.length;
    }
}
