// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AwarenessCodex
/// @notice Covenant contract to encode clarity, mindfulness, and awareness safeguards
/// @dev Provides structured rituals for awareness enforcement across governance layers
contract AwarenessCodex {
    address public overseer;
    uint256 public covenantCount;

    struct AwarenessRule {
        uint256 id;
        string principle;       // Awareness principle (e.g., clarity, mindfulness, presence)
        bool clear;             // True if clarity safeguard is active
        bool mindful;           // True if mindfulness safeguard is active
        bool present;           // True if presence safeguard is active
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => AwarenessRule) public rules;

    event AwarenessLogged(
        uint256 indexed id,
        string principle,
        bool clear,
        bool mindful,
        bool present,
        string notes
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs awareness principle with safeguards
    function logRule(
        string calldata principle,
        bool clear,
        bool mindful,
        bool present,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        rules[covenantCount] = AwarenessRule({
            id: covenantCount,
            principle: principle,
            clear: clear,
            mindful: mindful,
            present: present,
            notes: notes,
            timestamp: block.timestamp
        });
        emit AwarenessLogged(covenantCount, principle, clear, mindful, present, notes);
    }

    /// @notice Governance rule: if clear == false or mindful == false, mark as awareness breach
    function isAwarenessBreach(uint256 id) external view returns (bool) {
        AwarenessRule memory r = rules[id];
        return (!r.clear || !r.mindful);
    }
}
