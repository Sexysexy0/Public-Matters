// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BitcoinMinimalismDoctrineProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward); _; }

    struct MinimalismClause {
        uint256 id;
        string protocolFeature;
        string bloatRisk;
        string emotionalTag;
        string restraintPrinciple;
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => MinimalismClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event MinimalismClauseActivated(uint256 indexed id, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateMinimalismClause(
        string calldata protocolFeature,
        string calldata bloatRisk,
        string calldata emotionalTag,
        string calldata restraintPrinciple,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = MinimalismClause({
            id: id,
            protocolFeature: protocolFeature,
            bloatRisk: bloatRisk,
            emotionalTag: emotionalTag,
            restraintPrinciple: restraintPrinciple,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit MinimalismClauseActivated(id, emotionalTag);
    }

    function getMinimalismClause(uint256 id) external view returns (MinimalismClause memory) {
        return clauses[id];
    }
}
