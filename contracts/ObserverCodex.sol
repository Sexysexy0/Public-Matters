// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ObserverCodex
/// @notice Covenant contract to encode observer role, detachment safeguards, and governance perspective rituals
/// @dev Provides structured rituals for awareness, perspective, and detachment in governance
contract ObserverCodex {
    address public overseer;
    uint256 public covenantCount;

    struct ObserverRule {
        uint256 id;
        string principle;       // Observer principle (e.g., detachment, awareness, perspective)
        bool detached;          // True if detachment safeguard is active
        bool aware;             // True if awareness safeguard is active
        bool balanced;          // True if perspective safeguard is active
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => ObserverRule) public rules;

    event ObserverLogged(
        uint256 indexed id,
        string principle,
        bool detached,
        bool aware,
        bool balanced,
        string notes
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs observer principle with safeguards
    function logRule(
        string calldata principle,
        bool detached,
        bool aware,
        bool balanced,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        rules[covenantCount] = ObserverRule({
            id: covenantCount,
            principle: principle,
            detached: detached,
            aware: aware,
            balanced: balanced,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ObserverLogged(covenantCount, principle, detached, aware, balanced, notes);
    }

    /// @notice Governance rule: if detached == false or aware == false, mark as observer breach
    function isObserverBreach(uint256 id) external view returns (bool) {
        ObserverRule memory r = rules[id];
        return (!r.detached || !r.aware);
    }
}
