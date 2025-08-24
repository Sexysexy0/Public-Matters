// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title HealingSignalEmitter
/// @notice Emits planetary healing signals upon flaw resolution in SelfHealingLawProtocol
contract HealingSignalEmitter {
    address public steward;
    uint256 public signalCount;

    struct HealingSignal {
        uint256 id;
        string ritualName;
        string resolutionSummary;
        address emitter;
        uint256 timestamp;
    }

    mapping(uint256 => HealingSignal) public signals;

    event HealingSignalBroadcasted(
        uint256 indexed id,
        string ritualName,
        string resolutionSummary,
        address indexed emitter,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        signalCount = 0;
    }

    /// @notice Emit a healing signal after flaw resolution
    function broadcastHealingSignal(string calldata ritualName, string calldata resolutionSummary) external onlySteward {
        signals[signalCount] = HealingSignal({
            id: signalCount,
            ritualName: ritualName,
            resolutionSummary: resolutionSummary,
            emitter: msg.sender,
            timestamp: block.timestamp
        });

        emit HealingSignalBroadcasted(signalCount, ritualName, resolutionSummary, msg.sender, block.timestamp);
        signalCount++;
    }

    /// @notice Retrieve a healing signal by ID
    function getSignal(uint256 id) external view returns (HealingSignal memory) {
        require(id < signalCount, "Signal does not exist");
        return signals[id];
    }

    /// @notice Transfer stewardship to another scrollsmith
    function transferStewardship(address newSteward) external onlySteward {
        steward = newSteward;
    }
}
