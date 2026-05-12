// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RevealSignalVault {
    struct Signal {
        address participant;
        string source;
        uint256 timestamp;
        bool confirmed;
    }

    Signal[] public signals;

    event SignalLogged(address indexed participant, string source);
    event SignalConfirmed(uint256 indexed id, address verifier);

    function logSignal(string memory _source) public {
        signals.push(Signal(msg.sender, _source, block.timestamp, false));
        emit SignalLogged(msg.sender, _source);
    }

    function confirmSignal(uint256 _id) public {
        require(_id < signals.length, "Invalid ID");
        signals[_id].confirmed = true;
        emit SignalConfirmed(_id, msg.sender);
    }

    function getSignal(uint256 _id) public view returns (Signal memory) {
        require(_id < signals.length, "Invalid ID");
        return signals[_id];
    }

    function totalSignals() public view returns (uint256) {
        return signals.length;
    }
}
