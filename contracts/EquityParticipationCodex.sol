// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityParticipationCodex
/// @notice Codex covenant to document participatory equity principles in governance
contract EquityParticipationCodex {
    address public overseer;
    uint256 public codexCount;

    struct EquityParticipation {
        uint256 id;
        string principle;   // e.g. shared responsibility, proportional representation
        string safeguard;   // fairness, dignity, accountability
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => EquityParticipation) public participations;

    event ParticipationLogged(uint256 indexed id, string principle, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs participatory equity principle
    function logParticipation(string calldata principle, string calldata safeguard, string calldata notes) external onlyOverseer {
        codexCount++;
        participations[codexCount] = EquityParticipation({
            id: codexCount,
            principle: principle,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ParticipationLogged(codexCount, principle, safeguard, notes);
    }

    /// @notice Citizens can view participatory equity principles
    function viewParticipation(uint256 id) external view returns (EquityParticipation memory) {
        return participations[id];
    }
}
