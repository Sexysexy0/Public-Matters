// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TaxReliefEscrow is Ownable {

    constructor() Ownable(msg.sender) {}

    event RefundReleased(address operator, uint256 amount);

    function releaseRefund(address _operator, uint256 _amount) external {
        (bool success, ) = payable(_operator).call{value: _amount}(""); require(success, "Transfer failed");
        emit RefundReleased(_operator, _amount);
        // ESCROW: Retroactive 280E refund deployed.
    }
}
