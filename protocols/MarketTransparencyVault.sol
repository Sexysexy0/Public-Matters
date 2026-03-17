// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MarketTransparencyVault {
    address public owner;
    mapping(string => uint) public marketFlows;

    event FlowLogged(string marketType, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function logFlow(string memory marketType, uint amount) public {
        require(msg.sender == owner, "Only owner can log");
        marketFlows[marketType] += amount;
        emit FlowLogged(marketType, amount);
    }

    function getFlow(string memory marketType) public view returns (uint) {
        return marketFlows[marketType];
    }
}
