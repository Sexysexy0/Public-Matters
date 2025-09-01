// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollchainLoyaltyProtocol {
    struct LoyaltyRecord {
        address steward;
        uint256 totalSpent;
        uint256 loyaltyPoints;
    }

    mapping(address => LoyaltyRecord) public records;
    uint256 public transactionTaxRate = 1; // 1%

    event LoyaltyUpdated(address indexed steward, uint256 pointsEarned, uint256 taxApplied);

    function recordTransaction(address _steward, uint256 _amount) public {
        uint256 tax = (_amount * transactionTaxRate) / 100;
        uint256 points = (_amount - tax) / 100; // 1 point per ₱100 spent

        records[_steward].totalSpent += _amount;
        records[_steward].loyaltyPoints += points;

        emit LoyaltyUpdated(_steward, points, tax);
    }

    function getLoyaltyPoints(address _steward) public view returns (uint256) {
        return records[_steward].loyaltyPoints;
    }
}
