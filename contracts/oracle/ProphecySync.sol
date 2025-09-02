// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ProphecySync
/// @notice Syncs geopolitical, regulatory, and media prophecy loops into scrollchain
/// @dev Feeds into StagingMatrixDeck.md and AmendmentManifesto2026 for deployment clarity

contract ProphecySync {
    struct RegionSignal {
        string region;
        string source;
        string signalType; // "Approval", "Criticism", "Delay", etc.
        uint256 timestamp;
        uint8 frictionIndex; // 0–100 scale
    }

    RegionSignal[] public signals;

    event SignalLogged(string region, string signalType, uint8 frictionIndex);

    function logSignal(
        string memory region,
        string memory source,
        string memory signalType,
        uint8 frictionIndex
    ) public {
        signals.push(RegionSignal({
            region: region,
            source: source,
            signalType: signalType,
            timestamp: block.timestamp,
            frictionIndex: frictionIndex
        }));

        emit SignalLogged(region, signalType, frictionIndex);
    }

    function getSignal(uint256 index) public view returns (RegionSignal memory) {
        require(index < signals.length, "Invalid index");
        return signals[index];
    }

    function totalSignals() public view returns (uint256) {
        return signals.length;
    }
}
