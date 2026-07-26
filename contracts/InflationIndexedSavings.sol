// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IInflationOracle {
    /// @notice Returns inflation rate in basis points (e.g. 300 = 3%)
    function latestInflationRate() external view returns (uint256);
}

contract InflationIndexedSavings is Ownable {
    IERC20 public stablecoin;
    IInflationOracle public oracle;

    struct Deposit {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Deposit) public deposits;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 payout, uint256 inflationRate);
    event ReserveFunded(address indexed from, uint256 amount);

    constructor(address _stablecoin, address _oracle) Ownable(msg.sender) {
        stablecoin = IERC20(_stablecoin);
        oracle = IInflationOracle(_oracle);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit > 0");
        stablecoin.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] = Deposit(amount, block.timestamp);
        emit Deposited(msg.sender, amount);
    }

    function fundReserve(uint256 amount) external onlyOwner {
        require(amount > 0, "Reserve > 0");
        stablecoin.transferFrom(msg.sender, address(this), amount);
        emit ReserveFunded(msg.sender, amount);
    }

    function withdraw() external {
        Deposit memory dep = deposits[msg.sender];
        require(dep.amount > 0, "No deposit");

        uint256 inflationRate = oracle.latestInflationRate(); // e.g. 300 = 3%
        uint256 adjusted = dep.amount + (dep.amount * inflationRate) / 10000;

        delete deposits[msg.sender];

        require(stablecoin.balanceOf(address(this)) >= adjusted, "Insufficient reserve");
(bool success, ) = payable(        stablecoin).call{value: msg.sender, adjusted}(""); require(success, "Transfer failed");

        emit Withdrawn(msg.sender, adjusted, inflationRate);
    }
}
