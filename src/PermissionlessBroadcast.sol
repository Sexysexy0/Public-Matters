// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract PermissionlessBroadcast {
    address public broadcastOwner;
    event BroadcastSent(address indexed broadcaster, string content, uint256 timestamp);

    constructor() {
        broadcastOwner = msg.sender;
    }

    function dispatchTransmission(string calldata content, address payable fallbackNode) external payable {
        // Restricted destination access logic to block arbitrary manipulation
        require(msg.sender == broadcastOwner || fallbackNode == broadcastOwner, "Unauthorized broadcast interaction route");
        require(fallbackNode != address(0), "Invalid broadcast target node");

        emit BroadcastSent(msg.sender, content, block.timestamp);

        if (msg.value > 0) {
            (bool success, ) = fallbackNode.call{value: msg.value}("");
            require(success, "Node distribution failure");
        }
    }
}
