// BullRunProtocol.sol
pragma solidity ^0.8.0;

contract BullRunProtocol {
    struct Signal {
        uint256 id;
        string indicator;   // e.g. "Oversold Zone", "ETF Volume"
        string strength;    // e.g. "Strong", "Weak"
        uint256 timestamp;
    }

    uint256 public signalCount;
    mapping(uint256 => Signal) public signals;

    event SignalLogged(uint256 id, string indicator, string strength, uint256 timestamp);
    event BullDeclared(string message);

    function logSignal(string memory indicator, string memory strength) public {
        signalCount++;
        signals[signalCount] = Signal(signalCount, indicator, strength, block.timestamp);
        emit SignalLogged(signalCount, indicator, strength, block.timestamp);
    }

    function declareBull() public {
        emit BullDeclared("Bull Run Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
