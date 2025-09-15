// SPDX-License-Identifier: TenderSanctum
pragma solidity ^0.8.19;

contract UniversalTenderSanctifier {
    enum TenderType { Fiat, Crypto, Gold, Silver, Other }

    struct Payment {
        TenderType tender;
        string assetName;
        uint256 valueUSD;
        string purpose;
        bool accepted;
    }

    mapping(bytes32 => Payment) public payments;

    event PaymentSubmitted(string assetName, TenderType tender, uint256 valueUSD, string purpose);
    event PaymentAccepted(string assetName, string purpose);

    function submitPayment(string memory assetName, TenderType tender, uint256 valueUSD, string memory purpose) public {
        bytes32 paymentId = keccak256(abi.encodePacked(assetName, block.timestamp));
        payments[paymentId] = Payment(tender, assetName, valueUSD, purpose, false);
        emit PaymentSubmitted(assetName, tender, valueUSD, purpose);
    }

    function acceptPayment(string memory assetName, string memory purpose) public {
        bytes32 paymentId = keccak256(abi.encodePacked(assetName, block.timestamp));
        payments[paymentId].accepted = true;
        emit PaymentAccepted(assetName, purpose);
    }

    function getPaymentStatus(string memory assetName, string memory purpose) public view returns (Payment memory) {
        bytes32 paymentId = keccak256(abi.encodePacked(assetName, block.timestamp));
        return payments[paymentId];
    }
}
