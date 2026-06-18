// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityCodex
/// @notice Covenant contract to encode systemic equity, balance of power, and fairness safeguards
/// @dev Provides structured rituals for equity enforcement across governance layers
contract EquityCodex {
    address public overseer;
    uint256 public covenantCount;

    struct EquityRule {
        uint256 id;
        string principle;       // Equity principle (e.g., balance of power, equal opportunity, fairness)
        bool balanced;          // True if balance safeguard is active
        bool inclusive;         // True if inclusivity safeguard is active
        bool fair;              // True if fairness safeguard is active
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => EquityRule) public rules;

    event EquityLogged(
        uint256 indexed id,
        string principle,
        bool balanced,
        bool inclusive,
        bool fair,
        string notes
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs equity principle with safeguards
    function logRule(
        string calldata principle,
        bool balanced,
        bool inclusive,
        bool fair,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        rules[covenantCount] = EquityRule({
            id: covenantCount,
            principle: principle,
            balanced: balanced,
            inclusive: inclusive,
            fair: fair,
            notes: notes,
            timestamp: block.timestamp
        });
        emit EquityLogged(covenantCount, principle, balanced, inclusive, fair, notes);
    }

    /// @notice Governance rule: if balanced == false or inclusive == false, mark as inequitable
    function isInequitable(uint256 id) external view returns (bool) {
        EquityRule memory r = rules[id];
        return (!r.balanced || !r.inclusive);
    }
}
