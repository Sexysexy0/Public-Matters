// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KinderQueenVisibilityKit {
    struct PresenceLog {
        string zoneName;
        uint256 timestamp;
        uint8 visibilityScore;     // 1–10 scale
        uint8 empathyScore;        // Emotional APR
        bool guardianCertified;    // True if steward is Kinder Queen–approved
        string emotionalTag;       // e.g., "Reassuring", "Playful", "Protective"
    }

    PresenceLog[] public logs;

    event PresenceLogged(
        string zoneName,
        uint256 timestamp,
        uint8 visibilityScore,
        uint8 empathyScore,
        bool guardianCertified,
        string emotionalTag
    );

    function logPresence(
        string memory _zoneName,
        uint8 _visibilityScore,
        uint8 _empathyScore,
        bool _guardianCertified,
        string memory _emotionalTag
    ) public {
        logs.push(PresenceLog(
            _zoneName,
            block.timestamp,
            _visibilityScore,
            _empathyScore,
            _guardianCertified,
            _emotionalTag
        ));
        emit PresenceLogged(_zoneName, block.timestamp, _visibilityScore, _empathyScore, _guardianCertified, _emotionalTag);
    }

    function getPresence(uint256 index) public view returns (PresenceLog memory) {
        require(index < logs.length, "Invalid index");
        return logs[index];
    }

    function totalLogs() public view returns (uint256) {
        return logs.length;
    }
}
