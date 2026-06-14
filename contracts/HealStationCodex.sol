// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HealStationCodex
/// @notice Codex covenant to expand support role with deployable heal stations
contract HealStationCodex {
    address public overseer;
    uint256 public codexCount;

    struct HealRecord {
        uint256 id;
        string institution;   // squad, faction, or operator team
        uint256 healAmount;   // HP restored
        bool unfreeze;        // true if removes freeze effect
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => HealRecord) public records;

    event HealLogged(uint256 indexed id, string institution, uint256 healAmount, bool unfreeze, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs heal station deployment record
    function logHeal(string calldata institution, uint256 healAmount, bool unfreeze, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = HealRecord({
            id: codexCount,
            institution: institution,
            healAmount: healAmount,
            unfreeze: unfreeze,
            notes: notes,
            timestamp: block.timestamp
        });
        emit HealLogged(codexCount, institution, healAmount, unfreeze, notes);
    }

    /// @notice Citizens can view heal station records
    function viewHeal(uint256 id) external view returns (HealRecord memory) {
        return records[id];
    }
}
