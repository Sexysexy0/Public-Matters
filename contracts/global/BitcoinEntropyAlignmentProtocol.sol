// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BitcoinEntropyAlignmentProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward); _; }

    struct EntropyClause {
        uint256 id;
        string protocolChange;
        string entropyRisk;
        string emotionalTag;
        string alignmentPrinciple;
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => EntropyClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event EntropyClauseActivated(uint256 indexed id, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateEntropyClause(
        string calldata protocolChange,
        string calldata entropyRisk,
        string calldata emotionalTag,
        string calldata alignmentPrinciple,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = EntropyClause({
            id: id,
            protocolChange: protocolChange,
            entropyRisk: entropyRisk,
            emotionalTag: emotionalTag,
            alignmentPrinciple: alignmentPrinciple,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit EntropyClauseActivated(id, emotionalTag);
    }

    function getEntropyClause(uint256 id) external view returns (EntropyClause memory) {
        return clauses[id];
    }
}
