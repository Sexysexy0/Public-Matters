// SPDX-License-Identifier: SellerSanctum
pragma solidity ^0.8.19;

contract SellerRewardRouter {
    struct Seller {
        string name;
        string tier; // "reseller", "wholesaler", "verified"
        uint256 totalSales;
        uint256 rewardCredits;
    }

    mapping(address => Seller) public sellers;

    event SellerRegistered(address indexed steward, string name, string tier);
    event SaleRecorded(address indexed steward, uint256 saleAmount);
    event RewardGranted(address indexed steward, uint256 rewardCredits);

    function registerSeller(string memory name, string memory tier) public {
        sellers[msg.sender] = Seller(name, tier, 0, 0);
        emit SellerRegistered(msg.sender, name, tier);
    }

    function recordSale(address steward, uint256 saleAmount) public {
        Seller storage s = sellers[steward];
        s.totalSales += saleAmount;

        uint256 reward = calculateReward(s.tier, saleAmount);
        s.rewardCredits += reward;

        emit SaleRecorded(steward, saleAmount);
        emit RewardGranted(steward, reward);
    }

    function calculateReward(string memory tier, uint256 saleAmount) internal pure returns (uint256) {
        if (keccak256(bytes(tier)) == keccak256(bytes("wholesaler"))) {
            return saleAmount / 10; // 10% reward
        } else if (keccak256(bytes(tier)) == keccak256(bytes("reseller"))) {
            return saleAmount / 20; // 5% reward
        } else {
            return saleAmount / 25; // 4% reward for verified micro-sellers
        }
    }

    function getSellerStatus(address steward) public view returns (Seller memory) {
        return sellers[steward];
    }
}
