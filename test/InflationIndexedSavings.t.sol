// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/InflationIndexedSavings.sol";
import "../contracts/mocks/ERC20Mock.sol";

contract MockOracle is IInflationOracle {
    uint256 public rate;
    function setRate(uint256 _rate) external {
        rate = _rate;
    }
    function latestInflationRate() external view override returns (uint256) {
        return rate;
    }
}

contract InflationIndexedSavingsTest is Test {
    InflationIndexedSavings savings;
    MockOracle oracle;
    ERC20Mock stable;

    address owner = address(this);
    address user = address(0x123);

    function setUp() public {
        stable = new ERC20Mock("MockUSD", "MUSD", user, 1_000_000 ether);
        oracle = new MockOracle();
        savings = new InflationIndexedSavings(address(stable), address(oracle));

        vm.startPrank(user);
        stable.approve(address(savings), type(uint256).max);
        vm.stopPrank();

        stable.mint(owner, 1_000_000 ether);
        stable.approve(address(savings), type(uint256).max);
        savings.fundReserve(1_000_000 ether);
    }

    function testDepositAndWithdrawWithInflation() public {
        uint256 initialBalance = stable.balanceOf(user); // 1,000,000 ether

        vm.startPrank(user);
        savings.deposit(100 ether);
        oracle.setRate(300); // 300 basis points = 3%
        savings.withdraw();
        vm.stopPrank();

        uint256 balance = stable.balanceOf(user);
        // User deposited 100, got back 103 (3% inflation adjustment)
        // Net gain = 3 ether
        assertEq(balance, initialBalance + 3 ether, "Adjusted payout should include inflation");
    }
}
