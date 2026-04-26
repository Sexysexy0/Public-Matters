// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubscriptionReliefLedger {
    event ReliefSeal(string tier, uint256 oldPrice, uint256 newPrice);

    function logReduction(string memory _tier, uint256 _oldPrice, uint256 _newPrice) external {
        emit ReliefSeal(_tier, _oldPrice, _newPrice);
        // RULE: Subscription price reductions logged for governance.
    }
}
