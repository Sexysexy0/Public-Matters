// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MindfulnessCodex
/// @notice Covenant contract to encode deep presence, calm safeguards, and mindful governance rituals
/// @dev Provides structured rituals for mindfulness enforcement across governance layers
contract MindfulnessCodex {
    address public overseer;
    uint256 public covenantCount;

    struct MindfulnessRule {
        uint256 id;
        string principle;       // Mindfulness principle (e.g., presence, calm, focus)
        bool present;           // True if deep presence safeguard is active
        bool calm;              // True if calm safeguard is active
        bool focused;           // True if focus safeguard is active
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => MindfulnessRule) public rules;

    event MindfulnessLogged(
        uint256 indexed id,
        string principle,
        bool present,
        bool calm,
        bool focused,
        string notes
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs mindfulness principle with safeguards
    function logRule(
        string calldata principle,
        bool present,
        bool calm,
        bool focused,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        rules[covenantCount] = MindfulnessRule({
            id: covenantCount,
            principle: principle,
            present: present,
            calm: calm,
            focused: focused,
            notes: notes,
            timestamp: block.timestamp
        });
        emit MindfulnessLogged(covenantCount, principle, present, calm, focused, notes);
    }

    /// @notice Governance rule: if present == false or calm == false, mark as mindfulness breach
    function isMindfulnessBreach(uint256 id) external view returns (bool) {
        MindfulnessRule memory r = rules[id];
        return (!r.present || !r.calm);
    }
}
