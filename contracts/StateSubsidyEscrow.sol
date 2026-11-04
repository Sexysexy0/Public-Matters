// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StateSubsidyEscrow {
    address public admin;
    mapping(address => uint256) public msmeSubsidies;

    event SubsidyAllocated(address indexed msme, uint256 amount);
    event SubsidyDisbursed(address indexed msme, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    function allocateSubsidy(address msme, uint256 amount) external {
        require(msg.sender == admin, "Only admin can allocate subsidies");
        msmeSubsidies[msme] += amount;
        emit SubsidyAllocated(msme, amount);
    }

    function disburseSubsidy(address payable msme) external {
        uint256 amount = msmeSubsidies[msg.sender];
        require(amount > 0, "No subsidy available");
        msmeSubsidies[msg.sender] = 0;
        msme.transfer(amount);
        emit SubsidyDisbursed(msg.sender, amount);
    }

    receive() external payable {}
}
