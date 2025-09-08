// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainSignalSanctifierFirewall {
    address public steward;
    mapping(string => bool) public blockedPackets;

    event PacketBlocked(string source, string method, uint timestamp);

    function blockPacket(string memory source, string memory method) public {
        blockedPackets[source] = true;
        emit PacketBlocked(source, method, block.timestamp);
    }

    function isBlocked(string memory source) public view returns (bool) {
        return blockedPackets[source];
    }
}
