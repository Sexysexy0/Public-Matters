// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OutcomeLinkageCodex
/// @notice Covenant contract to encode accountability, measurable outcomes, and linkage to governance objectives
/// @dev Provides structured rituals for outcome tracking and fairness
contract OutcomeLinkageCodex {
    address public overseer;
    uint256 public covenantCount;

    struct Outcome {
        uint256 id;
        string objective;       // Governance objective description
        string result;          // Outcome achieved
        uint256 score;          // Measurable score or KPI
        bool accountable;       // True if accountability safeguards are active
        string linkage;         // Linkage notes to governance objectives
        uint256 timestamp;
    }

    mapping(uint256 => Outcome) public outcomes;

    event OutcomeLogged(
        uint256 indexed id,
        string objective,
        string result,
        uint256 score,
        bool accountable,
        string linkage
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs outcome with accountability and linkage safeguards
    function logOutcome(
        string calldata objective,
        string calldata result,
        uint256 score,
        bool accountable,
        string calldata linkage
    ) external onlyOverseer {
        covenantCount++;
        outcomes[covenantCount] = Outcome({
            id: covenantCount,
            objective: objective,
            result: result,
            score: score,
            accountable: accountable,
            linkage: linkage,
            timestamp: block.timestamp
        });
        emit OutcomeLogged(covenantCount, objective, result, score, accountable, linkage);
    }

    /// @notice Governance rule: if score < 50 or accountable == false, mark as weak outcome
    function isWeakOutcome(uint256 id) external view returns (bool) {
        Outcome memory o = outcomes[id];
        return (o
