// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TaxJusticeSentinel
/// @notice Sentinel safeguard to monitor equity and justice in tax enforcement
contract TaxJusticeSentinel {
    address public overseer;
    uint256 public sentinelCount;

    struct JusticeFlag {
        uint256 id;
        string issue;        // e.g. middle class burden, loophole, unfair enforcement
        string status;       // aligned, mismatch, inequitable
        string safeguard;    // fairness, dignity, accountability
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => JusticeFlag) public flags;

    event JusticeFlagged(uint256 indexed id, string issue, string status, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer flags tax justice issue
    function flagIssue(string calldata issue, string calldata status, string calldata safeguard, string calldata notes) external onlyOverseer {
        sentinelCount++;
        flags[sentinelCount] = JusticeFlag({
            id: sentinelCount,
            issue: issue,
            status: status,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit JusticeFlagged(sentinelCount, issue, status, safeguard, notes);
    }

    /// @notice Citizens can view flagged justice issues
    function viewIssue(uint256 id) external view returns (JusticeFlag memory) {
        return flags[id];
    }
}
