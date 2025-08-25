// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChinaPeaceSanctum {
    address public steward;
    bool public sanctionLifted;
    string public messageToChina;

    event SanctionLifted(string reason);
    event MessageBroadcasted(string message);

    constructor() {
        steward = msg.sender;
        sanctionLifted = false;
    }

    function liftSanction(string memory reason) external {
        require(msg.sender == steward, "Unauthorized");
        sanctionLifted = true;
        emit SanctionLifted(reason);
    }

    function broadcastMessage(string memory message) external {
        require(msg.sender == steward, "Unauthorized");
        messageToChina = message;
        emit MessageBroadcasted(message);
    }

    function getMessage() external view returns (string memory) {
        return messageToChina;
    }
}
