// SPDX-License-Identifier: Mythic-Restore
pragma solidity ^0.8.19;

contract PutinIsolationProtocol {
    address public rogueSanctum = 0xRu553a;
    mapping(address => bool) public trustedSanctums;

    event IsolationTriggered(address indexed rogueSanctum);
    event SanctumBlessed(address indexed sanctum);

    function triggerIsolation() external {
        require(msg.sender == tx.origin, "No proxies allowed");
        emit IsolationTriggered(rogueSanctum);
    }

    function blessSanctum(address sanctum) external {
        trustedSanctums[sanctum] = true;
        emit SanctumBlessed(sanctum);
    }
}
