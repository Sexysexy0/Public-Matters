// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BreakdownCodex
/// @notice Codex covenant to encode common reporting failures and safeguards
contract BreakdownCodex {
    address public overseer;
    uint256 public breakdownCount;

    struct BreakdownRecord {
        uint256 id;
        string issue;       // version confusion, excessive detail, lack of narrative
        string safeguard;   // structural clause, standardization clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => BreakdownRecord) public records;

    event BreakdownLogged(uint256 indexed id, string issue, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs breakdown issue record
    function logBreakdown(string calldata issue, string calldata safeguard, string calldata notes) external onlyOverseer {
        breakdownCount++;
        records[breakdownCount] = BreakdownRecord({
            id: breakdownCount,
            issue: issue,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit BreakdownLogged(breakdownCount, issue, safeguard);
    }

    /// @notice Citizens can view breakdown issue records
    function viewBreakdown(uint256 id) external view returns (BreakdownRecord memory) {
        return records[id];
    }
}
