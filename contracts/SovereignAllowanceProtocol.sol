// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignAllowanceProtocol {
    struct Allowance {
        uint256 amountPerCycle;
        uint256 lastClaimed;
    }

    mapping(address => Allowance) public allowances;

    event AllowanceConfigured(address indexed beneficiary, uint256 amount);
    event AllowanceClaimed(address indexed beneficiary, uint256 amount);

    function configureAllowance(address _beneficiary, uint256 _amount) public {
        allowances[_beneficiary] = Allowance({amountPerCycle: _amount, lastClaimed: 0});
        emit AllowanceConfigured(_beneficiary, _amount);
    }

    function claimAllowance() public {
        Allowance storage alloc = allowances[msg.sender];
        require(alloc.amountPerCycle > 0, "No allowance configured");

        alloc.lastClaimed = block.timestamp;

        (bool success, ) = payable(msg.sender).call{value: alloc.amountPerCycle}("");
        require(success, "Transfer failed");

        emit AllowanceClaimed(msg.sender, alloc.amountPerCycle);
    }

    receive() external payable {}
}
