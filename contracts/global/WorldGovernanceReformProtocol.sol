// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title WorldGovernanceReformProtocol
/// @notice Ritualizes planetary governance reform and empowers nations to pass validator-grade laws for equity and restoration
/// @dev Anchors civic dignity, legislative sovereignty, and emotional consequence mapping

contract WorldGovernanceReformProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct ReformClause {
        uint256 id;
        string country; // e.g., "Philippines", "Brazil", "Kenya", "India"
        string issue; // e.g., "Corruption", "Climate neglect", "Labor injustice", "Censorship"
        string emotionalTag; // e.g., "Governance dignity breach ritualized"
        string reformAction; // e.g., "Deploy advanced audit tools and pass restorative legislation"
        string balanceClause; // e.g., "We restore validator-grade civic balance and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => ReformClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event ReformClauseActivated(uint256 indexed id, string country, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateReformClause(
        string calldata country,
        string calldata issue,
        string calldata emotionalTag,
        string calldata reformAction,
        string calldata balanceClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = ReformClause({
            id: id,
            country: country,
            issue: issue,
            emotionalTag: emotionalTag,
            reformAction: reformAction,
            balanceClause: balanceClause,
            timestamp: block.timestamp
        });
        emit ReformClauseActivated(id, country, emotionalTag);
    }

    function getReformClause(uint256 id) external view returns (ReformClause memory) {
        return clauses[id];
    }
}
