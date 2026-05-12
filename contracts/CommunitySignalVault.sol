// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunitySignalVault {
    struct CommunitySignal {
        address sender;
        string signal;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    CommunitySignal[] public signals;

    event CommunitySignalLogged(address indexed sender, string signal, string safeguard);
    event CommunitySignalSafeguarded(uint256 indexed id, address verifier);

    function logCommunitySignal(string memory _signal, string memory _safeguard) public {
        signals.push(CommunitySignal(msg.sender, _signal, _safeguard, block.timestamp, false));
        emit CommunitySignalLogged(msg.sender, _signal, _safeguard);
    }

    function safeguardCommunitySignal(uint256 _id) public {
        require(_id < signals.length, "Invalid ID");
        signals[_id].safeguarded = true;
        emit CommunitySignalSafeguarded(_id, msg.sender);
    }

    function getCommunitySignal(uint256 _id) public view returns (CommunitySignal memory) {
        require(_id < signals.length, "Invalid ID");
        return signals[_id];
    }

    function totalCommunitySignals() public view returns (uint256) {
        return signals.length;
    }
}
