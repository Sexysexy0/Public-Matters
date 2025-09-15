// SPDX-License-Identifier: TradeSanctum
pragma solidity ^0.8.19;

contract PhysicalTradeCollectorRouter {
    struct TradeEvent {
        string senderCountry;
        string receiverCountry;
        string assetType; // e.g., "Gold", "Grain", "Oil", "Machinery"
        uint256 quantity;
        string collectorEntity;
        bool delivered;
        bool verified;
    }

    mapping(bytes32 => TradeEvent) public trades;

    event TradeTagged(string senderCountry, string receiverCountry, string assetType);
    event DeliveryVerified(string collectorEntity, string assetType);

    function tagTrade(string memory senderCountry, string memory receiverCountry, string memory assetType, uint256 quantity, string memory collectorEntity) public {
        bytes32 tradeId = keccak256(abi.encodePacked(senderCountry, receiverCountry, assetType, block.timestamp));
        trades[tradeId] = TradeEvent(senderCountry, receiverCountry, assetType, quantity, collectorEntity, false, false);
        emit TradeTagged(senderCountry, receiverCountry, assetType);
    }

    function verifyDelivery(string memory senderCountry, string memory receiverCountry, string memory assetType, string memory collectorEntity) public {
        bytes32 tradeId = keccak256(abi.encodePacked(senderCountry, receiverCountry, assetType, block.timestamp));
        trades[tradeId].delivered = true;
        trades[tradeId].verified = true;
        emit DeliveryVerified(collectorEntity, assetType);
    }

    function getTradeStatus(string memory senderCountry, string memory receiverCountry, string memory assetType) public view returns (TradeEvent memory) {
        bytes32 tradeId = keccak256(abi.encodePacked(senderCountry, receiverCountry, assetType, block.timestamp));
        return trades[tradeId];
    }
}
