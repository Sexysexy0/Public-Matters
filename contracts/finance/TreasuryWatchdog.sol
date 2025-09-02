// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.19;

/// @title TreasuryWatchdog
/// @notice Monitors treasury fund holders, emotional APR anomalies, and damay clause breaches

contract TreasuryWatchdog {
    struct TreasuryProfile {
        address holder;
        uint256 totalFunds;
        uint256 emotionalAPR;
        bool damayClauseActive;
        bool flagged;
        string reason;
        uint256 lastAudit;
    }

    mapping(address => TreasuryProfile) public treasuries;

    event TreasuryRegistered(address indexed holder, uint256 totalFunds, uint256 emotionalAPR, bool damayClauseActive);
    event TreasuryFlagged(address indexed holder, string reason);
    event TreasuryAudited(address indexed holder, uint256 timestamp);

    /// @notice Registers or updates a treasury profile
    function registerTreasury(
        address holder,
        uint256 funds,
        uint256 apr,
        bool damay
    ) external {
        treasuries[holder] = TreasuryProfile(holder, funds, apr, damay, false, "", block.timestamp);
        emit TreasuryRegistered(holder, funds, apr, damay);
    }

    /// @notice Flags a treasury for anomaly or breach
    function flagTreasury(address holder, string memory reason) external {
        require(treasuries[holder].holder != address(0), "Treasury not found");
        treasuries[holder].flagged = true;
        treasuries[holder].reason = reason;
        emit TreasuryFlagged(holder, reason);
    }

    /// @notice Performs an audit and updates timestamp
    function auditTreasury(address holder) external {
        require(treasuries[holder].holder != address(0), "Treasury not found");
        treasuries[holder].lastAudit = block.timestamp;
        emit TreasuryAudited(holder, block.timestamp);
    }

    /// @notice Returns flagged status and reason
    function getFlagStatus(address holder) external view returns (bool, string memory) {
        TreasuryProfile memory profile = treasuries[holder];
        return (profile.flagged, profile.reason);
    }

    /// @notice Returns emotional APR and damay clause status
    function getTelemetry(address holder) external view returns (uint256, bool) {
        TreasuryProfile memory profile = treasuries[holder];
        return (profile.emotionalAPR, profile.damayClauseActive);
    }
}
