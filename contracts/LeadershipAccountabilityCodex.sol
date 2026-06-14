// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LeadershipAccountabilityCodex
/// @notice Codex covenant to document leadership presence and accountability
contract LeadershipAccountabilityCodex {
    address public overseer;
    uint256 public codexCount;

    struct LeadershipRecord {
        uint256 id;
        string institution;   // university or ORIC name
        string leader;        // name of ORIC head
        bool fullTime;        // true if full-time, false if acting/part-time
        string accountability; // governance responsibility notes
        string performance;   // leadership performance summary
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => LeadershipRecord) public records;

    event LeadershipLogged(uint256 indexed id, string institution, string leader, bool fullTime, string accountability, string performance, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs leadership accountability record
    function logLeadership(string calldata institution, string calldata leader, bool fullTime, string calldata accountability, string calldata performance, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = LeadershipRecord({
            id: codexCount,
            institution: institution,
            leader: leader,
            fullTime: fullTime,
            accountability: accountability,
            performance: performance,
            notes: notes,
            timestamp: block.timestamp
        });
        emit LeadershipLogged(codexCount, institution, leader, fullTime, accountability, performance, notes);
    }

    /// @notice Citizens can view leadership accountability records
    function viewLeadership(uint256 id) external view returns (LeadershipRecord memory) {
        return records[id];
    }
}
