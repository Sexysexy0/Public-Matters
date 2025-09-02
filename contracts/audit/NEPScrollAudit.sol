// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.19;

/// @title NEPScrollAudit
/// @notice Audits NEP fund releases with emotional telemetry and damay clause

contract NEPScrollAudit {
    struct FundRelease {
        uint256 amount;
        string purpose;
        uint256 emotionalAPR;
        bool damayClause;
        uint256 timestamp;
    }

    mapping(address => FundRelease[]) public releases;

    event FundReleased(address indexed agency, uint256 amount, string purpose, uint256 emotionalAPR, bool damayClause);

    function releaseFunds(
        address agency,
        uint256 amount,
        string memory purpose,
        uint256 apr,
        bool damay
    ) external {
        releases[agency].push(FundRelease(amount, purpose, apr, damay, block.timestamp));
        emit FundReleased(agency, amount, purpose, apr, damay);
    }

    function getLatestRelease(address agency) external view returns (FundRelease memory) {
        uint256 len = releases[agency].length;
        require(len > 0, "No releases found");
        return releases[agency][len - 1];
    }
}
