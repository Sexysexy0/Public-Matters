// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntegritySeparation
/// @notice Covenant to separate spiritual issues from physical problems
contract IntegritySeparation {
    address public oversightCommittee;
    uint256 public separationCount;

    struct SeparationRecord {
        uint256 id;
        string category;    // spiritual or physical
        string description; // issue or problem description
        bool active;
        uint256 timestamp;
    }

    mapping(uint256 => SeparationRecord) public records;

    event SeparationLogged(uint256 indexed id, string category, string description, bool active);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs separation of issues
    function logSeparation(string calldata category, string calldata description) external onlyOversight {
        separationCount++;
        records[separationCount] = SeparationRecord({
            id: separationCount,
            category: category,
            description: description,
            active: true,
            timestamp: block.timestamp
        });
        emit SeparationLogged(separationCount, category, description, true);
    }

    /// @notice Oversight deactivates a separation record
    function deactivateSeparation(uint256 id) external onlyOversight {
        records[id].active = false;
        emit SeparationLogged(id, records[id].category, records[id].description, false);
    }

    /// @notice Citizens can view separation records
    function viewSeparation(uint256 id) external view returns (SeparationRecord memory) {
        return records[id];
    }
}
