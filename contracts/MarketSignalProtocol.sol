pragma solidity ^0.8.20;

contract MarketSignalProtocol {
    address public admin;

    struct Signal {
        string asset;        // e.g. stocks, gold, silver
        string trend;        // e.g. muted, all-time high
        uint256 timestamp;
    }

    Signal[] public signals;

    event SignalLogged(string asset, string trend, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSignal(string calldata asset, string calldata trend) external onlyAdmin {
        signals.push(Signal(asset, trend, block.timestamp));
        emit SignalLogged(asset, trend, block.timestamp);
    }

    function totalSignals() external view returns (uint256) {
        return signals.length;
    }
}
