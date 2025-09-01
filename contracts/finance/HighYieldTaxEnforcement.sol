// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HighYieldTaxEnforcement {
    struct Withdrawal {
        address user;
        uint256 amount;
        uint256 taxRate;
        uint256 taxDue;
        bool processed;
    }

    mapping(address => Withdrawal[]) public withdrawals;
    uint256 public millionaireThreshold = 1_000_000 ether;
    uint256 public billionaireThreshold = 1_000_000_000 ether;

    event TaxAssessed(address indexed user, uint256 amount, uint256 taxRate, uint256 taxDue);

    function assessWithdrawal(address _user, uint256 _amount) public {
        uint256 rate = getTaxRate(_amount);
        uint256 tax = (_amount * rate) / 100;
        withdrawals[_user].push(Withdrawal(_user, _amount, rate, tax, true));
        emit TaxAssessed(_user, _amount, rate, tax);
    }

    function getTaxRate(uint256 _amount) public view returns (uint256) {
        if (_amount >= billionaireThreshold) {
            return 25; // Billionaire tier
        } else if (_amount >= millionaireThreshold) {
            return 15; // Millionaire tier
        } else {
            return 5;  // Standard tier
        }
    }

    function getUserWithdrawals(address _user) public view returns (Withdrawal[] memory) {
        return withdrawals[_user];
    }
}
