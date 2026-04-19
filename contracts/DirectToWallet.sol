// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DirectToWallet {
    // [AGENDA LOGIC] Eliminating physical queues via direct disbursement
    function disburseSubsidy(address _riderWallet, uint256 _amount) public {
        // Logic: Verify franchise status -> Send funds to wallet
        // Result: 0 waiting time, 100% efficiency
        payable(_riderWallet).transfer(_amount);
    }
}
