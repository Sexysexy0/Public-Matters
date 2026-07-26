// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/InflationIndexedSavings.sol";

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
    IERC20 stable;

    address user = address(0x123);

    function setUp() public {
        // deploy mock stablecoin
        stable = IERC20(address(new ERC20Mock("MockUSD", "MUSD", user, 1_000_000 ether)));
        oracle = new MockOracle();
        savings = new InflationIndexedSavings(address(stable), address(oracle));

        // approve contract
        vm.startPrank(user);
        ERC20Mock(address(stable)).approve(address(savings), type(uint256).max);
        vm.stopPrank();
    }

    function testDepositAndWithdrawWithInflation() public {
        vm.startPrank(user);
        savings.deposit(100 ether);
        oracle.setRate(300); // 3% inflation
        savings.withdraw();
        vm.stopPrank();

        uint256 balance = stable.balanceOf(user);
        assertEq(balance, 100 ether + 3 ether, "Adjusted payout should include inflation");
    }
}
