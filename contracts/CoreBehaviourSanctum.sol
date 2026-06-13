// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CoreBehaviourSanctum
/// @notice Sanctum covenant to clean and align core system behaviour
contract CoreBehaviourSanctum {
    address public oversightCommittee;
    uint256 public sanctumCount;

    struct BehaviourRecord {
        uint256 id;
        string domain;     // e.g. tech, creative, governance
        string habit;      // unwanted, clean, aligned
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => BehaviourRecord) public records;

    event BehaviourLogged(uint256 indexed id, string domain, string habit, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs behaviour status for a domain
    function logBehaviour(string calldata domain, string calldata habit, string calldata notes) external onlyOversight {
        sanctumCount++;
        records[sanctumCount] = BehaviourRecord({
            id: sanctumCount,
            domain: domain,
            habit: habit,
            notes: notes,
            timestamp: block.timestamp
        });
        emit BehaviourLogged(sanctumCount, domain, habit, notes);
    }

    /// @notice Citizens can view behaviour records
    function viewBehaviour(uint256 id) external view returns (BehaviourRecord memory) {
        return records[id];
    }
}
