// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Treasury {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(amount);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}
