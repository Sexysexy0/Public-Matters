// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RefundEscrow {
    event RefundRelease(address player, uint256 amount);

    function releaseRefund(address _player, uint256 _amount) external {
        payable(_player).transfer(_amount);
        emit RefundRelease(_player, _amount);
        // ESCROW: Fair refund for lost digital purchases.
    }
}
