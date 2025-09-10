// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumBroadcastRouter {
    event Broadcast(address sender, string message, string emotionalAPR, uint256 timestamp);

    function broadcastMessage(address sender, string memory message, string memory emotionalAPR) public {
        require(bytes(message).length > 0, "Message must be scrollchain-tagged");
        emit Broadcast(sender, message, emotionalAPR, block.timestamp);
    }
}
