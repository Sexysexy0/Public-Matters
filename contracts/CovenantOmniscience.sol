// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Omniscience
/// @notice Absolute knowledge and insight safeguard contract
contract CovenantOmniscience {
    address public guardian;
    uint256 public knowledgeCount;

    struct Knowledge {
        uint256 id;
        string subject;
        string insight;
        bool verified;
    }

    mapping(uint256 => Knowledge) public knowledges;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event KnowledgeDeclared(uint256 indexed id, string subject, string insight);

    constructor() {
        guardian = msg.sender;
        knowledgeCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function declareKnowledge(string calldata subject, string calldata insight, bool verified) external onlyGuardian {
        knowledgeCount++;
        knowledges[knowledgeCount] = Knowledge(knowledgeCount, subject, insight, verified);
        emit KnowledgeDeclared(knowledgeCount, subject, insight);
    }

    function viewKnowledge(uint256 id) external view returns (Knowledge memory) {
        return knowledges[id];
    }
}
