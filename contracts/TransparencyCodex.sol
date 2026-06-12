// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyCodex
/// @notice Immutable record of government decisions and budget allocations
contract TransparencyCodex {
    address public oversightCommittee;
    uint256 public recordCount;

    struct Record {
        uint256 id;
        string decision;
        uint256 timestamp;
    }

    mapping(uint256 => Record) public records;

    event RecordLogged(uint256 indexed id, string decision);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee logs government decisions
    function logDecision(string calldata decision) external onlyOversight {
        recordCount++;
        records[recordCount] = Record({
            id: recordCount,
            decision: decision,
            timestamp: block.timestamp
        });
        emit RecordLogged(recordCount, decision);
    }

    /// @notice Citizens can view logged decisions
    function viewDecision(uint256 id) external view returns (Record memory) {
        return records[id];
    }
}
