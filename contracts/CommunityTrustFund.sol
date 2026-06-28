// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityTrustFund
/// @notice Covenant contract to establish a shared fund for collective community support
contract CommunityTrustFund {
    address public overseer;
    uint256 public fundBalance;

    struct ContributionRecord {
        address contributor;
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => ContributionRecord[]) public contributions;

    event ContributionReceived(address indexed contributor, uint256 amount, uint256 timestamp);
    event FundAllocated(address indexed overseer, uint256 amount, uint256 timestamp);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
        fundBalance = 0;
    }

    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        fundBalance += msg.value;
        contributions[msg.sender].push(ContributionRecord(msg.sender, msg.value, block.timestamp));
        emit ContributionReceived(msg.sender, msg.value, block.timestamp);
    }

    function allocate(uint256 amount, address payable recipient) external onlyOverseer {
        require(amount <= fundBalance, "Insufficient funds");
        fundBalance -= amount;
        recipient.transfer(amount);
        emit FundAllocated(overseer, amount, block.timestamp);
    }

    function viewContributor(address contributor) external view returns (ContributionRecord[] memory) {
        return contributions[contributor];
    }

    function getBalance() external view returns (uint256) {
        return fundBalance;
    }
}
