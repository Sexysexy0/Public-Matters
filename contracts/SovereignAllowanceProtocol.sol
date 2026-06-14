// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract SovereignAllowanceProtocol {
    address public guardian;
    struct Allowance { uint256 amountPerCycle; uint256 nextReleaseTime; uint256 lastWithdrawn; bool isActive; }
    mapping(address => Allowance) public allowances;
    uint256 public constant CYCLE_DURATION = 7 days;
    event AllowanceConfigured(address indexed beneficiary, uint256 amount);
    event FundsWithdrawn(address indexed beneficiary, uint256 amount);
    modifier onlyGuardian() { require(msg.sender == guardian, "Error: Access denied."); _;
    }
    constructor() { guardian = msg.sender; }
    function configureAllowance(address _beneficiary, uint256 _amountPerCycle) public onlyGuardian {
        allowances[_beneficiary] = Allowance({ amountPerCycle: _amountPerCycle, nextReleaseTime: block.timestamp, lastWithdrawn: 0, isActive: true });
        emit AllowanceConfigured(_beneficiary, _amountPerCycle);
    }
    function revokeAllowance(address _beneficiary) public onlyGuardian {
        allowances[_beneficiary].isActive = false;
    }
    function claimAllowance() public {
        Allowance storage alloc = allowances[msg.sender];
        require(alloc.isActive, "Error: Allowance is inactive or revoked.");
        require(block.timestamp >= alloc.nextReleaseTime, "Error: Cycle timelock active.");
        require(address(this).balance >= alloc.amountPerCycle, "Error: Insufficient vault liquidity.");
        alloc.nextReleaseTime = block.timestamp + CYCLE_DURATION;
        alloc.lastWithdrawn = block.timestamp;
        payable(msg.sender).transfer(alloc.amountPerCycle);
        emit FundsWithdrawn(msg.sender, alloc.amountPerCycle);
    }
    receive() external payable {}
}
