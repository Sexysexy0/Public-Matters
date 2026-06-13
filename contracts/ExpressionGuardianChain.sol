// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ExpressionGuardianChain
/// @notice Chain covenant to safeguard diversity of creative expressions
contract ExpressionGuardianChain {
    address public oversightCommittee;
    uint256 public chainCount;

    struct ExpressionRecord {
        uint256 id;
        string industry;     // e.g. music, movie, anime, philosophy
        string voice;        // representation of creative voice
        string status;       // active, suppressed, flagged
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ExpressionRecord) public records;

    event ExpressionLogged(uint256 indexed id, string industry, string voice, string status, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs a creative expression record
    function logExpression(string calldata industry, string calldata voice, string calldata status, string calldata notes) external onlyOversight {
        chainCount++;
        records[chainCount] = ExpressionRecord({
            id: chainCount,
            industry: industry,
            voice: voice,
            status: status,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ExpressionLogged(chainCount, industry, voice, status, notes);
    }

    /// @notice Citizens can view expression records
    function viewExpression(uint256 id) external view returns (ExpressionRecord memory) {
        return records[id];
    }
}
