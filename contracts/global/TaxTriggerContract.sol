// SPDX-License-Identifier: TaxSanctum
pragma solidity ^0.8.19;

contract TaxTriggerContract {
    struct Investor {
        address wallet;
        uint256 investedAmount;
        uint256 incomeGenerated;
        bool taxTriggered;
    }

    mapping(address => Investor) public investors;
    uint256 public taxRate = 10; // 10% default

    event InvestmentLogged(address investor, uint256 amount);
    event IncomeReported(address investor, uint256 income);
    event TaxActivated(address investor, uint256 taxAmount);

    function logInvestment(uint256 amount) public {
        investors[msg.sender] = Investor(msg.sender, amount, 0, false);
        emit InvestmentLogged(msg.sender, amount);
    }

    function reportIncome(uint256 income) public {
        require(investors[msg.sender].wallet != address(0), "Investor not registered");
        investors[msg.sender].incomeGenerated += income;
        emit IncomeReported(msg.sender, income);
    }

    function activateTax() public {
        Investor storage inv = investors[msg.sender];
        require(inv.incomeGenerated > 0, "No income to tax");
        require(!inv.taxTriggered, "Tax already triggered");

        uint256 taxAmount = (inv.incomeGenerated * taxRate) / 100;
        inv.taxTriggered = true;

        emit TaxActivated(msg.sender, taxAmount);
        // Optional: transfer taxAmount to treasury wallet
    }

    function getInvestorStatus(address investor) public view returns (Investor memory) {
        return investors[investor];
    }
}
