// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityHousingEscrow {
    mapping(address => uint256) public totalContributions;
    mapping(address => uint256) public monthlyAmortizationPledge;

    event ContributionReceived(address indexed beneficiary, uint256 amount);
    event PledgeSet(address indexed beneficiary, uint256 monthlyAmount);

    function setPledge(uint256 monthlyAmount) external {
        require(monthlyAmount <= 3500, "Amortization must fit minimum wage earner capacity (Max PHP 3,500)");
        monthlyAmortizationPledge[msg.sender] = monthlyAmount;
        emit PledgeSet(msg.sender, monthlyAmount);
    }

    function payAmortization() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        totalContributions[msg.sender] += msg.value;
        emit ContributionReceived(msg.sender, msg.value);
    }
}
