// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GamePassRelief {
    event ReliefRecord(string tier, uint256 oldPrice, uint256 newPrice);

    function logReduction(string memory _tier, uint256 _oldPrice, uint256 _newPrice) external {
        emit ReliefRecord(_tier, _oldPrice, _newPrice);
        // RULE: Subscription relief encoded for governance.
    }
}
