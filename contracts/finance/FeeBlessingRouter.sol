// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FeeBlessingRouter {
    mapping(address => uint256) public blessings;

    event BlessingDistributed(address indexed bank, uint256 amount);

    function distributeBlessing(address bank, uint256 amount) external payable {
        require(msg.value == amount, "Blessing mismatch");
        blessings[bank] += amount;
        (bool success, ) = payable(bank).call{value: amount}(""); require(success, "Transfer failed");
        emit BlessingDistributed(bank, amount);
    }

    function getBlessing(address bank) external view returns (uint256) {
        return blessings[bank];
    }
}
