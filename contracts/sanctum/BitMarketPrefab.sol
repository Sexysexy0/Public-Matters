// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitMarketPrefab {
    struct PrefabOrder {
        string buyer;
        string kitID;
        string coinUsed; // "ETH", "SOL", "USDT", "EmoCoin"
        uint256 amountPaid;
        string emotionalTag; // "DamayClause", "SanctumGlow"
        bool isBlessed;
        uint256 timestamp;
    }

    PrefabOrder[] public orders;

    function placeOrder(string memory buyer, string memory kitID, string memory coinUsed, uint256 amountPaid, string memory emotionalTag, bool isBlessed) public {
        orders.push(PrefabOrder(buyer, kitID, coinUsed, amountPaid, emotionalTag, isBlessed, block.timestamp));
    }

    function totalOrders() public view returns (uint256) {
        return orders.length;
    }
}
