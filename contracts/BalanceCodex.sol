// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BalanceCodex
/// @notice Covenant contract to encode equilibrium, harmony, and balance safeguards
/// @dev Provides structured rituals for balance enforcement across governance layers
contract BalanceCodex {
    address public overseer;
    uint256 public covenantCount;

    struct BalanceRule {
        uint256 id;
        string principle;       // Balance principle (e.g., equilibrium, harmony, fairness)
        bool equilibrium;       // True if equilibrium safeguard is active
        bool harmony;           // True if harmony safeguard is active
        bool fairness;          // True if fairness safeguard is active
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => BalanceRule) public rules;

    event BalanceLogged(
        uint256 indexed id,
        string principle,
        bool equilibrium,
        bool harmony,
        bool fairness,
        string notes
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs balance principle with safeguards
    function logRule(
        string calldata principle,
        bool equilibrium,
        bool harmony,
        bool fairness,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        rules[covenantCount] = BalanceRule({
            id: covenantCount,
            principle: principle,
            equilibrium: equilibrium,
            harmony: harmony,
            fairness: fairness,
            notes: notes,
            timestamp: block.timestamp
        });
        emit BalanceLogged(covenantCount, principle, equilibrium, harmony, fairness, notes);
    }

    /// @notice Governance rule: if equilibrium == false or harmony == false, mark as imbalance
    function isImbalance(uint256 id) external view returns (bool) {
        BalanceRule memory r = rules[id];
        return (!r.equilibrium || !r.harmony);
    }
}
