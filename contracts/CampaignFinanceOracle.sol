// CampaignFinanceOracle.sol
pragma solidity ^0.8.0;

contract CampaignFinanceOracle {
    uint256 public constant SPENDING_LIMIT = 100_000_000; // e.g., 100M PHP

    struct CandidateFinance {
        uint256 totalDonations;
        uint256 totalSpent;
        bool isFlagged;
    }

    mapping(address => CandidateFinance) public finances;

    function logExpense(uint256 _amount) public {
        finances[msg.sender].totalSpent += _amount;
        if (finances[msg.sender].totalSpent > SPENDING_LIMIT) {
            finances[msg.sender].isFlagged = true;
        }
    }
}
