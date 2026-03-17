// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Dividend {
    address public founder;
    mapping(address => uint256) public shares;
    uint256 public totalShares;
    address[] public holders;

    constructor() {
        founder = msg.sender;
        shares[founder] = 100;
        totalShares = 100;
        holders.push(founder);
    }

    receive() external payable {}

    function addHolder(address holder, uint256 share) public {
        require(msg.sender == founder, "Only founder can add");
        holders.push(holder);
        shares[holder] = share;
        totalShares += share;
    }

    function distribute() public {
        require(msg.sender == founder, "Only founder can distribute");
        uint256 amount = address(this).balance;
        for (uint i = 0; i < holders.length; i++) {
            address holder = holders[i];
            uint256 payout = (amount * shares[holder]) / totalShares;
            payable(holder).transfer(payout);
        }
    }
}
