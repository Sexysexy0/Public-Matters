// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Treasury
/// @notice Transparent financial backbone for covenant governance
contract CovenantTreasury {
    address public guardian;
    mapping(address => uint256) public balances;
    uint256 public totalFunds;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event FundsDeposited(address indexed from, uint256 amount);
    event FundsWithdrawn(address indexed to, uint256 amount);
    event FundsAllocated(address indexed to, uint256 amount, string purpose);

    constructor() {
        guardian = msg.sender;
        totalFunds = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑deposit ng pondo sa treasury
    function deposit() external payable {
        balances[msg.sender] += msg.value;
        totalFunds += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    /// @notice Mag‑withdraw ng pondo (guardian only)
    function withdraw(address payable to, uint256 amount) external onlyGuardian {
        require(amount <= totalFunds, "Insufficient funds");
        totalFunds -= amount;
        to.transfer(amount);
        emit FundsWithdrawn(to, amount);
    }

    /// @notice Mag‑allocate ng pondo para sa governance purpose
    function allocate(address payable to, uint256 amount, string calldata purpose) external onlyGuardian {
        require(amount <= totalFunds, "Insufficient funds");
        totalFunds -= amount;
        to.transfer(amount);
        emit FundsAllocated(to, amount, purpose);
    }

    /// @notice Tingnan ang balance ng isang address
    function viewBalance(address holder) external view returns (uint256) {
        return balances[holder];
    }
}
