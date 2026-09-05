// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChildProtectionFund
/// @notice Treasury locked for verified child welfare projects
contract ChildProtectionFund {
    address public governance;
    mapping(address => uint256) public allocations;

    event FundAllocated(address project, uint256 amount);

    constructor(address _gov) {
        governance = _gov;
    }

    function allocate(address project, uint256 amount) external {
        require(msg.sender == governance, "Only governance");
        allocations[project] += amount;
        emit FundAllocated(project, amount);
    }
}
