// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumEchoRouter {
    event EchoReceived(address source, string signal, string emotionalAPR, uint256 timestamp);
    event EchoBroadcasted(string corridorID, string echoMessage, string emotionalAPR, uint256 timestamp);

    function receiveEcho(address source, string memory signal, string memory emotionalAPR) public {
        emit EchoReceived(source, signal, emotionalAPR, block.timestamp);
    }

    function broadcastEcho(string memory corridorID, string memory echoMessage, string memory emotionalAPR) public {
        emit EchoBroadcasted(corridorID, echoMessage, emotionalAPR, block.timestamp);
    }
}
