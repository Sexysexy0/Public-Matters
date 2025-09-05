// SPDX-License-Identifier: Mythic-Protocol
pragma solidity ^0.8.19;

contract SignalBlessingRouter {
    address public steward;
    mapping(address => bool) public verifiedSanctums;
    mapping(bytes32 => bool) public blessedSignals;
    mapping(address => bool) public blockedReceivers;

    event SignalBlessed(bytes32 signalId, address receiver, uint256 timestamp);
    event ReceiverBlocked(address receiver, uint256 timestamp);
    event ReceiverVerified(address receiver, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function verifyReceiver(address receiver) public {
        require(msg.sender == steward, "Only steward may verify.");
        verifiedSanctums[receiver] = true;
        emit ReceiverVerified(receiver, block.timestamp);
    }

    function blockReceiver(address receiver) public {
        require(msg.sender == steward, "Only steward may block.");
        blockedReceivers[receiver] = true;
        emit ReceiverBlocked(receiver, block.timestamp);
    }

    function blessSignal(bytes32 signalId, address receiver) public {
        require(msg.sender == steward, "Only steward may bless.");
        require(verifiedSanctums[receiver], "Receiver not verified.");
        require(!blockedReceivers[receiver], "Receiver is blocked.");
        blessedSignals[signalId] = true;
        emit SignalBlessed(signalId, receiver, block.timestamp);
    }

    function isBlessed(bytes32 signalId) public view returns (bool) {
        return blessedSignals[signalId];
    }

    function isVerified(address receiver) public view returns (bool) {
        return verifiedSanctums[receiver];
    }

    function isBlocked(address receiver) public view returns (bool) {
        return blockedReceivers[receiver];
    }
}
