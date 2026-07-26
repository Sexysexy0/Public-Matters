// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CompensationPlusShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event CompensationPlusSeal(address worker, uint256 basePay, uint256 extraPay);

    function releasePayment(address worker, uint256 basePay) external {
        uint256 extraPay = basePay / 10; // 10% pasobra allowance
        emit CompensationPlusSeal(worker, basePay, extraPay);
        // RULE: Workers receive full pay plus inconvenience allowance.
    }
}
