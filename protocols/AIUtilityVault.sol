// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AIUtilityVault {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function fundAI(uint amount) public {
        require(msg.sender == owner, "Only owner can fund");
        payable(owner).transfer(amount);
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}
