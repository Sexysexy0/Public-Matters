// FuelVoucherDistribution.sol
pragma solidity ^0.8.0;

contract FuelVoucherDistribution {
    mapping(address => uint256) public voucherBalance;
    uint256 public subsidyAmount = 15; // 15 PHP subsidy per liter

    function distributeVoucher(address recipient, uint256 amount) public {
        // Only authorized government agency can call this
        voucherBalance[recipient] += amount;
    }

    function redeemVoucher(uint256 liters) public {
        require(voucherBalance[msg.sender] >= liters, "Insufficient vouchers");
        voucherBalance[msg.sender] -= liters;
    }
}
