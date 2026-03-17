// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAOFund {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function withdraw(uint amount, address to) public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(to).transfer(amount);
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}
