// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TaxReliefEscrow {
    event RefundReleased(address operator, uint256 amount);

    function releaseRefund(address _operator, uint256 _amount) external {
        payable(_operator).transfer(_amount);
        emit RefundReleased(_operator, _amount);
        // ESCROW: Retroactive 280E refund deployed.
    }
}
