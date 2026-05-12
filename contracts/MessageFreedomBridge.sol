// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MessageFreedomBridge {
    struct MessageSignal {
        address sender;
        string signal;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    MessageSignal[] public signals;

    event MessageLogged(address indexed sender, string signal, string safeguard);
    event MessageSafeguarded(uint256 indexed id, address verifier);

    function logMessage(string memory _signal, string memory _safeguard) public {
        signals.push(MessageSignal(msg.sender, _signal, _safeguard, block.timestamp, false));
        emit MessageLogged(msg.sender, _signal, _safeguard);
    }

    function safeguardMessage(uint256 _id) public {
        require(_id < signals.length, "Invalid ID");
        signals[_id].safeguarded = true;
        emit MessageSafeguarded(_id, msg.sender);
    }

    function getMessage(uint256 _id) public view returns (MessageSignal memory) {
        require(_id < signals.length, "Invalid ID");
        return signals[_id];
    }

    function totalMessages() public view returns (uint256) {
        return signals.length;
    }
}
