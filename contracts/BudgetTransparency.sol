// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BudgetTransparency is Ownable {

    constructor() Ownable(msg.sender) {}

    event AllocationMade(string purpose, uint256 amount, address recipient);

    // [Goal: Absolute Financial Honesty]
    function allocateFunds(string memory _purpose, uint256 _amount) external {
        // Action: Broadcast every allocation to the entire network. No secrets.
        emit AllocationMade(_purpose, _amount, msg.sender);
    }
}
