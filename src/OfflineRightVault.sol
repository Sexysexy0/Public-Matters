// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OfflineRightVault {
    address public publisher;
    uint256 public lastHeartbeat;
    uint256 public constant HEARTBEAT_TIMEOUT = 90 days;
    string private offlineDecryptionKeyHash;

    bool public isServerAbandoned;

    event HeartbeatUpdated(uint256 timestamp);
    event ServerMarkedAbandoned(uint256 timestamp);

    constructor(string memory _offlineKeyHash) {
        publisher = msg.sender;
        lastHeartbeat = block.timestamp;
        offlineDecryptionKeyHash = _offlineKeyHash;
    }

    function publisherHeartbeat() external {
        require(msg.sender == publisher, "Only publisher");
        lastHeartbeat = block.timestamp;
        emit HeartbeatUpdated(block.timestamp);
    }

    function triggerServerAbandonment() external {
        require(block.timestamp > lastHeartbeat + HEARTBEAT_TIMEOUT, "Server still active");
        isServerAbandoned = true;
        emit ServerMarkedAbandoned(block.timestamp);
    }

    function getOfflineDecryptionKey() external view returns (string memory) {
        require(isServerAbandoned, "Server is still running. Key locked.");
        return offlineDecryptionKeyHash;
    }
}
