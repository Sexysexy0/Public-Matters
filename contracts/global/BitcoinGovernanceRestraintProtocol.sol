// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BitcoinGovernanceRestraintProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward); _; }

    struct GovernanceClause {
        uint256 id;
        string breachType;
        string impactSummary;
        string emotionalTag;
        string restraintAction;
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => GovernanceClause> public clauses;

    event GovernanceClauseActivated(uint256 indexed id, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
    }

    function activateGovernanceClause(
        string calldata breachType,
        string calldata impactSummary,
        string calldata emotionalTag,
        string calldata restraintAction,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = GovernanceClause({
            id: id,
            breachType: breachType,
            impactSummary: impactSummary,
            emotionalTag: emotionalTag,
            restraintAction: restraintAction,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit GovernanceClauseActivated(id, emotionalTag);
    }

    function getGovernanceClause(uint256 id) external view returns (GovernanceClause memory) {
        return clauses[id];
    }
}
