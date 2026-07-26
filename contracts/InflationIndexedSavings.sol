// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IInflationOracle {
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

    constructor(address _stablecoin, address _oracle) {
        stablecoin = IERC20(_stablecoin);
        oracle = IInflationOracle(_oracle);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit > 0");
        stablecoin.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] = Deposit(amount, block.timestamp);
        emit Deposited(msg.sender, amount);
    }

    function withdraw() external {
        Deposit memory dep = deposits[msg.sender];
        require(dep.amount > 0, "No deposit");

        uint256 inflationRate = oracle.latestInflationRate(); // e.g. 3% = 300 basis points
        uint256 adjusted = dep.amount + (dep.amount * inflationRate / 10000);

        delete deposits[msg.sender];
        stablecoin.transfer(msg.sender, adjusted);

        emit Withdrawn(msg.sender, adjusted, inflationRate);
    }
}
