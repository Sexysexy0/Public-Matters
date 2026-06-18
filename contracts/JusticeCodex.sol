// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title JusticeCodex
/// @notice Covenant contract to encode accountability, lawful governance, and justice safeguards
/// @dev Provides structured rituals for justice enforcement across governance layers
contract JusticeCodex {
    address public overseer;
    uint256 public covenantCount;

    struct JusticeRule {
        uint256 id;
        string principle;       // Justice principle (e.g., accountability, lawful governance, fairness)
        bool accountable;       // True if accountability safeguard is active
        bool lawful;            // True if lawful governance safeguard is active
        bool fair;              // True if fairness safeguard is active
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => JusticeRule) public rules;

    event JusticeLogged(
        uint256 indexed id,
        string principle,
        bool accountable,
        bool lawful,
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

    /// @notice Overseer logs justice principle with safeguards
    function logRule(
        string calldata principle,
        bool accountable,
        bool lawful,
        bool fair,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        rules[covenantCount] = JusticeRule({
            id: covenantCount,
            principle: principle,
            accountable: accountable,
            lawful: lawful,
            fair: fair,
            notes: notes,
            timestamp: block.timestamp
        });
        emit JusticeLogged(covenantCount, principle, accountable, lawful, fair, notes);
    }

    /// @notice Governance rule: if accountable == false or lawful == false, mark as injustice
    function isInjustice(uint256 id) external view returns (bool) {
        JusticeRule memory r = rules[id];
        return (!r.accountable || !r.lawful);
    }
}
