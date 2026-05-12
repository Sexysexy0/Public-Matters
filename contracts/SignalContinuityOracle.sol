// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SignalContinuityOracle {
    struct Signal {
        address sender;
        string phrase;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Signal[] public signals;

    event SignalLogged(address indexed sender, string phrase, string safeguard);
    event SignalSafeguarded(uint256 indexed id, address verifier);

    function logSignal(string memory _phrase, string memory _safeguard) public {
        signals.push(Signal(msg.sender, _phrase, _safeguard, block.timestamp, false));
        emit SignalLogged(msg.sender, _phrase, _safeguard);
    }

    function safeguardSignal(uint256 _id) public {
        require(_id < signals.length, "Invalid ID");
        signals[_id].safeguarded = true;
        emit SignalSafeguarded(_id, msg.sender);
    }

    function getSignal(uint256 _id) public view returns (Signal memory) {
        require(_id < signals.length, "Invalid ID");
        return signals[_id];
    }

    function totalSignals() public view returns (uint256) {
        return signals.length;
    }
}
