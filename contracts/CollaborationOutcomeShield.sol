// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CollaborationOutcomeShield
/// @notice Shield covenant to enforce conversion of research linkages into funded outputs
contract CollaborationOutcomeShield {
    address public overseer;
    uint256 public shieldCount;

    struct CollaborationRecord {
        uint256 id;
        string institution;   // university or ORIC name
        string partner;       // external partner (industry, NGO, government)
        string linkageType;   // MoU, joint research, consortium
        string outcome;       // funded project, publication, commercialization
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CollaborationRecord) public records;

    event CollaborationLogged(uint256 indexed id, string institution, string partner, string linkageType, string outcome, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs collaboration outcome record
    function logCollaboration(string calldata institution, string calldata partner, string calldata linkageType, string calldata outcome, string calldata notes) external onlyOverseer {
        shieldCount++;
        records[shieldCount] = CollaborationRecord({
            id: shieldCount,
            institution: institution,
            partner: partner,
            linkageType: linkageType,
            outcome: outcome,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CollaborationLogged(shieldCount, institution, partner, linkageType, outcome, notes);
    }

    /// @notice Citizens can view collaboration outcome records
    function viewCollaboration(uint256 id) external view returns (CollaborationRecord memory) {
        return records[id];
    }
}
