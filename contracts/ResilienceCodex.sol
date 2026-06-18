// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResilienceCodex
/// @notice Covenant contract to encode adaptability, regeneration, and resilience safeguards in governance systems
/// @dev Provides structured rituals for resilience enforcement across governance layers
contract ResilienceCodex {
    address public overseer;
    uint256 public covenantCount;

    struct ResilienceRule {
        uint256 id;
        string principle;       // Resilience principle (e.g., adaptability, regeneration, sustainability)
        bool adaptable;         // True if adaptability safeguard is active
        bool regenerative;      // True if regeneration safeguard is active
        bool sustainable;       // True if sustainability safeguard is active
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => ResilienceRule) public rules;

    event ResilienceLogged(
        uint256 indexed id,
        string principle,
        bool adaptable,
        bool regenerative,
        bool sustainable,
        string notes
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs resilience principle with safeguards
    function logRule(
        string calldata principle,
        bool adaptable,
        bool regenerative,
        bool sustainable,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        rules[covenantCount] = ResilienceRule({
            id: covenantCount,
            principle: principle,
            adaptable: adaptable,
            regenerative: regenerative,
            sustainable: sustainable,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ResilienceLogged(covenantCount, principle, adaptable, regenerative, sustainable, notes);
    }

    /// @notice Governance rule: if adaptable == false or regenerative == false, mark as fragile
    function isFragile(uint256 id) external view returns (bool) {
        ResilienceRule memory r = rules[id];
        return (!r.adaptable || !r.regenerative);
    }
}
