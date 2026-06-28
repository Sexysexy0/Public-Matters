// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PersonalSupportFund
/// @notice Covenant contract to establish self-sustainability and personal support system
contract PersonalSupportFund {
    address public overseer;
    uint256 public fundBalance;

    struct SupportRecord {
        address supporter;
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => SupportRecord[]) public supporters;

    event SupportReceived(address indexed supporter, uint256 amount, uint256 timestamp);
    event FundWithdrawn(address indexed overseer, uint256 amount, uint256 timestamp);

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
        supporters[msg.sender].push(SupportRecord(msg.sender, msg.value, block.timestamp));
        emit SupportReceived(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(uint256 amount) external onlyOverseer {
        require(amount <= fundBalance, "Insufficient funds");
        fundBalance -= amount;
        payable(overseer).transfer(amount);
        emit FundWithdrawn(overseer, amount, block.timestamp);
    }

    function viewSupporter(address supporter) external view returns (SupportRecord[] memory) {
        return supporters[supporter];
    }

    function getBalance() external view returns (uint256) {
        return fundBalance;
    }
}
