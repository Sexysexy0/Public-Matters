// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BondMarketResilienceProtocol
/// @notice Ritualizes bond market breach tagging, anchors reform suggestions, and restores investor confidence
/// @dev Anchors validator-grade fiscal audit, emotional consequence mapping, and resilience activation

contract BondMarketResilienceProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct BondClause {
        uint256 id;
        string jurisdiction; // e.g., "Philippines"
        string breachType; // e.g., "Flood-control scandal", "Growth downgrade"
        string impactSummary; // e.g., "Investor confidence shaken, yields volatile"
        string reformSuggestions; // e.g., "Transparency in infra spending, ESG bond frameworks"
        bool resilienceActivated;
        bool emotionalTagged;
        string emotionalTag; // e.g., "Investor sanctum shaken"
        string restorationClause; // e.g., "We commit to fiscal clarity, ESG alignment, and investor dignity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => BondClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event BondClauseActivated(uint256 indexed id, string jurisdiction, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateBondClause(
        string calldata jurisdiction,
        string calldata breachType,
        string calldata impactSummary,
        string calldata reformSuggestions,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = BondClause({
            id: id,
            jurisdiction: jurisdiction,
            breachType: breachType,
            impactSummary: impactSummary,
            reformSuggestions: reformSuggestions,
            resilienceActivated: true,
            emotionalTagged: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit BondClauseActivated(id, jurisdiction, emotionalTag);
    }

    function getBondClause(uint256 id) external view returns (BondClause memory) {
        return clauses[id];
    }
}
