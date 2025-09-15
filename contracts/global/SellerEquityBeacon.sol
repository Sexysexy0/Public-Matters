// SPDX-License-Identifier: SellerSanctum
pragma solidity ^0.8.19;

contract SellerEquityBeacon {
    struct Seller {
        string name;
        string platform;
        uint256 totalSales;
        uint256 rewardCredits;
        bool equityTagged;
        string milestone;
    }

    mapping(address => Seller) public sellers;

    event SellerRegistered(address indexed steward, string name, string platform);
    event MilestoneBroadcasted(address indexed steward, string milestone);
    event EquityTagged(address indexed steward);
    event RewardUpdated(address indexed steward, uint256 rewardCredits);

    function registerSeller(string memory name, string memory platform) public {
        sellers[msg.sender] = Seller(name, platform, 0, 0, false, "None");
        emit SellerRegistered(msg.sender, name, platform);
    }

    function updateSales(address steward, uint256 saleAmount) public {
        Seller storage s = sellers[steward];
        s.totalSales += saleAmount;

        if (s.totalSales >= 10000 && keccak256(bytes(s.milestone)) != keccak256(bytes("Gold"))) {
            s.milestone = "Gold";
            emit MilestoneBroadcasted(steward, "Gold");
        } else if (s.totalSales >= 5000 && keccak256(bytes(s.milestone)) != keccak256(bytes("Silver"))) {
            s.milestone = "Silver";
            emit MilestoneBroadcasted(steward, "Silver");
        } else if (s.totalSales >= 1000 && keccak256(bytes(s.milestone)) != keccak256(bytes("Bronze"))) {
            s.milestone = "Bronze";
            emit MilestoneBroadcasted(steward, "Bronze");
        }

        uint256 reward = saleAmount / 20; // 5% reward
        s.rewardCredits += reward;
        emit RewardUpdated(steward, s.rewardCredits);
    }

    function tagEquity(address steward) public {
        sellers[steward].equityTagged = true;
        emit EquityTagged(steward);
    }

    function getSellerStatus(address steward) public view returns (Seller memory) {
        return sellers[steward];
    }
}
