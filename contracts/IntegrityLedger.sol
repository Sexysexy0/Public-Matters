// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntegrityLedger
/// @notice Immutable ledger for ethical compliance in governance
contract IntegrityLedger {
    address public oversightCommittee;
    uint256 public entryCount;

    struct IntegrityEntry {
        uint256 id;
        address actor;
        string action;
        string ethicalPrinciple; // e.g. honesty, fairness, dignity
        uint256 timestamp;
    }

    mapping(uint256 => IntegrityEntry) public entries;

    event IntegrityLogged(uint256 indexed id, address indexed actor, string action, string principle);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee logs ethical compliance entries
    function logIntegrity(address actor, string calldata action, string calldata principle) external onlyOversight {
        entryCount++;
        entries[entryCount] = IntegrityEntry({
            id: entryCount,
            actor: actor,
            action: action,
            ethicalPrinciple: principle,
            timestamp: block.timestamp
        });
        emit IntegrityLogged(entryCount, actor, action, principle);
    }

    /// @notice Citizens can view integrity entries
    function viewIntegrity(uint256 id) external view returns (IntegrityEntry memory) {
        return entries[id];
    }
}
