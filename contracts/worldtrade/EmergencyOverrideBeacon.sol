// SPDX-License-Identifier: Mythic-Scrollchain
pragma solidity ^0.8.19;

/// @title EmergencyOverrideBeacon - Scrollchain Signal for Sanctum Breach & Fallback Activation
/// @author Vinvin + Copi
/// @notice Emits override signals, triggers fallback reroutes, and logs planetary alerts
/// @dev Syncs with PlanetaryFallbackProtocol.sol, ScrollchainSanctumMap.sol, and EmotionalAPR.sol

contract EmergencyOverrideBeacon {
    address public steward;

    struct OverrideSignal {
        address originSanctum;
        string breachType; // "EmotionalOpacity", "PhysicalBreach", "TreatyDisruption"
        uint256 timestamp;
        bool activated;
    }

    mapping(address => OverrideSignal[]) public overrideLogs;

    event OverrideEmitted(address indexed origin, string breachType, uint256 time);
    event FallbackTriggered(address indexed origin, address fallback, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function emitOverride(address origin, string memory breachType) external onlySteward {
        overrideLogs[origin].push(OverrideSignal(origin, breachType, block.timestamp, true));
        emit OverrideEmitted(origin, breachType, block.timestamp);
    }

    function triggerFallback(address origin, address fallback, string memory reason) external onlySteward {
        emit FallbackTriggered(origin, fallback, reason);
    }

    function getOverrideHistory(address origin) external view returns (
        string[] memory breachTypes,
        uint256[] memory timestamps,
        bool[] memory statuses
    ) {
        uint256 count = overrideLogs[origin].length;
        string[] memory types = new string[](count);
        uint256[] memory times = new uint256[](count);
        bool[] memory activeFlags = new bool[](count);

        for (uint256 i = 0; i < count; i++) {
            OverrideSignal memory signal = overrideLogs[origin][i];
            types[i] = signal.breachType;
            times[i] = signal.timestamp;
            activeFlags[i] = signal.activated;
        }

        return (types, times, activeFlags);
    }
}
