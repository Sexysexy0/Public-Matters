// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InstitutionalAuditHistory {
    event AuditLog(address indexed actor, string action, bytes data);

    function logEvent(
        address actor,
        string memory action,
        bytes memory data
    ) external {
        emit AuditLog(actor, action, data);
    }
}
