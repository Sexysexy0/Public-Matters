// SPDX-License-Identifier: HumanitarianSanctum
pragma solidity ^0.8.19;

contract EssentialTradeBlessingRouter {
    struct TradeBlessing {
        address payerID;
        string payerName; // e.g., "Donald Trump"
        string receiverName; // e.g., "Narendra Modi"
        string commodityType; // e.g., "Fruits", "Food", "Medicine"
        uint256 paymentAmountUSD;
        bool tariffExempt;
        string stewardNote;
    }

    mapping(address => TradeBlessing) public blessingRegistry;

    event BlessingTagged(address payerID, string commodityType);
    event PaymentConfirmed(address payerID);

    function tagBlessing(
        address payerID,
        string memory payerName,
        string memory receiverName,
        string memory commodityType,
        uint256 paymentAmountUSD,
        bool tariffExempt,
        string memory stewardNote
    ) public {
        blessingRegistry[payerID] = TradeBlessing(
            payerID,
            payerName,
            receiverName,
            commodityType,
            paymentAmountUSD,
            tariffExempt,
            stewardNote
        );
        emit BlessingTagged(payerID, commodityType);
    }

    function confirmPayment(address payerID) public {
        require(bytes(blessingRegistry[payerID].payerName).length > 0, "Blessing not tagged");
        emit PaymentConfirmed(payerID);
    }

    function getBlessingStatus(address payerID) public view returns (TradeBlessing memory) {
        return blessingRegistry[payerID];
    }
}
