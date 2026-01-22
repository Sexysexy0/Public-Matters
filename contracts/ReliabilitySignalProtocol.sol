pragma solidity ^0.8.20;

contract ReliabilitySignalProtocol {
    address public admin;

    struct Signal {
        string marker;       // e.g. high-effort intelligence
        string reason;       // e.g. difficult to fabricate
        string credibility;  // e.g. strengthens Gospel reliability
        uint256 timestamp;
    }

    Signal[] public signals;

    event SignalLogged(string marker, string reason, string credibility, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSignal(string calldata marker, string calldata reason, string calldata credibility) external onlyAdmin {
        signals.push(Signal(marker, reason, credibility, block.timestamp));
        emit SignalLogged(marker, reason, credibility, block.timestamp);
    }

    function totalSignals() external view returns (uint256) {
        return signals.length;
    }
}
