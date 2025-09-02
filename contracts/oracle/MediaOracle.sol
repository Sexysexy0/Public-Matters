// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title MediaOracle
/// @notice Scores emotional APR from media feeds, prophecy loops, and sentiment spikes
/// @dev Feeds into ETFApprovalOracle.sol and ProphecySync.sol

contract MediaOracle {
    struct MediaPing {
        string headline;
        string region;
        uint256 timestamp;
        int8 sentimentScore; // -100 to +100
        uint8 emotionalAPR;  // 0–100 scale
    }

    MediaPing[] public pings;

    event MediaPingLogged(string headline, int8 sentimentScore, uint8 emotionalAPR);

    function logPing(
        string memory headline,
        string memory region,
        int8 sentimentScore,
        uint8 emotionalAPR
    ) public {
        pings.push(MediaPing({
            headline: headline,
            region: region,
            timestamp: block.timestamp,
            sentimentScore: sentimentScore,
            emotionalAPR: emotionalAPR
        }));

        emit MediaPingLogged(headline, sentimentScore, emotionalAPR);
    }

    function getPing(uint256 index) public view returns (MediaPing memory) {
        require(index < pings.length, "Invalid index");
        return pings[index];
    }

    function totalPings() public view returns (uint256) {
        return pings.length;
    }
}
