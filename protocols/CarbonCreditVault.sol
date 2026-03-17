// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarbonCreditVault {
    address public owner;
    mapping(address => uint) public credits;

    event CreditIssued(address indexed to, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function issueCredit(address to, uint amount) public {
        require(msg.sender == owner, "Only owner can issue credits");
        credits[to] += amount;
        emit CreditIssued(to, amount);
    }

    function balanceOf(address account) public view returns (uint) {
        return credits[account];
    }
}
