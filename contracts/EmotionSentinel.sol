// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EmotionSentinel
/// @notice Sentinel safeguard to monitor and control emotional drift in decision-making
contract EmotionSentinel {
    address public overseer;
    uint256 public alertCount;

    struct EmotionAlert {
        uint256 id;
        string emotion;      // e.g. revenge, obsession, fear, resolve
        string status;       // controlled, drift, critical
        string safeguard;    // rationality, detachment, clarity
        string resolution;   // cleanse, align, purge
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => EmotionAlert) public alerts;

    event EmotionFlagged(uint256 indexed id, string emotion, string status, string safeguard, string resolution, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer flags emotional drift
    function flagEmotion(string calldata emotion, string calldata status, string calldata safeguard, string calldata resolution, string calldata notes) external onlyOverseer {
        alertCount++;
        alerts[alertCount] = EmotionAlert({
            id: alertCount,
            emotion: emotion,
            status: status,
            safeguard: safeguard,
            resolution: resolution,
            notes: notes,
            timestamp: block.timestamp
        });
        emit EmotionFlagged(alertCount, emotion, status, safeguard, resolution, notes);
    }

    /// @notice Citizens can view emotion alerts
    function viewEmotion(uint256 id) external view returns (EmotionAlert memory) {
        return alerts[id];
    }
}
