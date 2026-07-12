// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Securityholder Rights Ledger
/// @notice Protects stakeholder rights and balances power in Public Matters system
contract SecurityholderRightsLedger {
    address public guardian;
    mapping(address => uint256) public shares;
    mapping(address => bool) public votingRights;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event SharesAssigned(address indexed holder, uint256 amount);
    event VotingRightsChanged(address indexed holder, bool status);

    constructor() {
        guardian = msg.sender;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑assign ng shares sa isang stakeholder
    function assignShares(address holder, uint256 amount) external onlyGuardian {
        shares[holder] += amount;
        emit SharesAssigned(holder, amount);
    }

    /// @notice Mag‑set ng voting rights para sa isang stakeholder
    function setVotingRights(address holder, bool status) external onlyGuardian {
        votingRights[holder] = status;
        emit VotingRightsChanged(holder, status);
    }

    /// @notice Tingnan ang shares ng isang stakeholder
    function viewShares(address holder) external view returns (uint256) {
        return shares[holder];
    }

    /// @notice Tingnan kung may voting rights ang isang stakeholder
    function hasVotingRights(address holder) external view returns (bool) {
        return votingRights[holder];
    }
}
