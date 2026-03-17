// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuditLogger {
    event ActionLogged(address indexed actor, string action, uint timestamp);

    function logAction(string memory action) public {
        emit ActionLogged(msg.sender, action, block.timestamp);
    }
}
