// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityTrustFund
/// @notice Covenant contract for collective resource stewardship
contract CommunityTrustFund {
    address public overseer;
    uint256 public fundBalance;
    uint256 public contributionCount;

    struct ContributionEntry {
        uint256 id;
        address contributor;
        uint256 amount;
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ContributionEntry) public contributions;

    event ContributionLogged(uint256 indexed id, address contributor, uint256 amount);
    event WithdrawalExecuted(address overseer, uint256 amount);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function contribute(string calldata notes) external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        contributionCount++;
        fundBalance += msg.value;
        contributions[contributionCount] = ContributionEntry({
            id: contributionCount,
            contributor: msg.sender,
            amount: msg.value,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ContributionLogged(contributionCount, msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external onlyOverseer {
        require(amount <= fundBalance, "Insufficient funds");
        fundBalance -= amount;
        payable(overseer).transfer(amount);
        emit WithdrawalExecuted(overseer, amount);
    }

    function viewContribution(uint256 id) external view returns (ContributionEntry memory) {
        return contributions[id];
    }
}
