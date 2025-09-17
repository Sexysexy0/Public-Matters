// SPDX-License-Identifier: RedistributionSanctum
pragma solidity ^0.8.19;

contract BlessingRedistributionRouter {
    address public steward;
    uint256 public redistributionPool;

    mapping(address => uint256) public blessingsReceived;

    event BonusRedirected(address indexed from, uint256 amount);
    event BlessingDistributed(address indexed to, uint256 amount);

    constructor() {
        steward = msg.sender;
    }

    function redirectBonus(address from, uint256 amount) public {
        require(msg.sender == steward, "Only steward may redirect bonuses");
        redistributionPool += amount;
        emit BonusRedirected(from, amount);
    }

    function distributeBlessing(address to, uint256 amount) public {
        require(msg.sender == steward, "Only steward may distribute blessings");
        require(amount <= redistributionPool, "Insufficient pool");
        blessingsReceived[to] += amount;
        redistributionPool -= amount;
        emit BlessingDistributed(to, amount);
    }

    function getBlessing(address recipient) public view returns (uint256) {
        return blessingsReceived[recipient];
    }
}
