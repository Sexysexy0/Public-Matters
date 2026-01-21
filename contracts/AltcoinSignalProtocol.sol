pragma solidity ^0.8.20;

contract AltcoinSignalProtocol {
    address public admin;

    struct Signal {
        string coin;         // e.g. XRP, ETH
        string pattern;      // e.g. rare 2022 signal, midlife crisis
        string effect;       // e.g. stalled rallies, institutional stress
        uint256 timestamp;
    }

    Signal[] public signals;

    event SignalLogged(string coin, string pattern, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSignal(string calldata coin, string calldata pattern, string calldata effect) external onlyAdmin {
        signals.push(Signal(coin, pattern, effect, block.timestamp));
        emit SignalLogged(coin, pattern, effect, block.timestamp);
    }

    function totalSignals() external view returns (uint256) {
        return signals.length;
    }
}
