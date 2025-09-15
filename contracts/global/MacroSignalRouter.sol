// SPDX-License-Identifier: MacroSanctum
pragma solidity ^0.8.19;

contract MacroSignalRouter {
    struct MacroSignal {
        string signalType; // e.g., "RSI", "FedRate", "BTC Dominance"
        string source;
        string interpretation;
        bool bullish;
        uint256 timestamp;
    }

    mapping(bytes32 => MacroSignal) public signals;

    event SignalTagged(string signalType, string interpretation);

    function tagSignal(string memory signalType, string memory source, string memory interpretation, bool bullish) public {
        bytes32 signalId = keccak256(abi.encodePacked(signalType, block.timestamp));
        signals[signalId] = MacroSignal(signalType, source, interpretation, bullish, block.timestamp);
        emit SignalTagged(signalType, interpretation);
    }

    function getSignal(string memory signalType) public view returns (MacroSignal memory) {
        bytes32 signalId = keccak256(abi.encodePacked(signalType, block.timestamp));
        return signals[signalId];
    }
}
