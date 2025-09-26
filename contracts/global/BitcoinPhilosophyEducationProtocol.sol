// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BitcoinNodeImmunityProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward); _; }

    struct ImmunityClause {
        uint256 id;
        string nodeVersion;
        string threatType;
        string emotionalTag;
        string protectionClause;
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => ImmunityClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event ImmunityClauseActivated(uint256 indexed id, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateImmunityClause(
        string calldata nodeVersion,
        string calldata threatType,
        string calldata emotionalTag,
        string calldata protectionClause,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = ImmunityClause({
            id: id,
            nodeVersion: nodeVersion,
            threatType: threatType,
            emotionalTag: emotionalTag,
            protectionClause: protectionClause,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ImmunityClauseActivated(id, emotionalTag);
    }

    function getImmunityClause(uint256 id) external view returns (ImmunityClause memory) {
        return clauses[id];
    }
}
