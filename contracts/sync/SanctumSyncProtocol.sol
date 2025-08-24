// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SanctumSyncProtocol
/// @notice Syncs routed signals and healing broadcasts across registered sanctums
contract SanctumSyncProtocol {
    address public steward;
    uint256 public syncCount;

    struct SyncLog {
        uint256 id;
        string signalType;
        string originProtocol;
        string payload;
        address sanctum;
        bool verified;
        uint256 timestamp;
    }

    mapping(uint256 => SyncLog) public syncLogs;

    event SanctumSynced(
        uint256 indexed id,
        string signalType,
        string originProtocol,
        string payload,
        address indexed sanctum,
        bool verified,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        syncCount = 0;
    }

    /// @notice Sync a signal to a sanctum and log the verification
    function syncToSanctum(
        string calldata signalType,
        string calldata originProtocol,
        string calldata payload,
        address sanctum,
        bool verified
    ) external onlySteward {
        syncLogs[syncCount] = SyncLog({
            id: syncCount,
            signalType: signalType,
            originProtocol: originProtocol,
            payload: payload,
            sanctum: sanctum,
            verified: verified,
            timestamp: block.timestamp
        });

        emit SanctumSynced(syncCount, signalType, originProtocol, payload, sanctum, verified, block.timestamp);
        syncCount++;
    }

    /// @notice Retrieve a sync log by ID
    function getSyncLog(uint256 id) external view returns (SyncLog memory) {
        require(id < syncCount, "Sync log does not exist");
        return syncLogs[id];
    }

    /// @notice Transfer stewardship to another scrollsmith
    function transferStewardship(address newSteward) external onlySteward {
        steward = newSteward;
    }
}
