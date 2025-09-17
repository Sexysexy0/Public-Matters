// SPDX-License-Identifier: PaymentSanctum
pragma solidity ^0.8.19;

contract MultiAssetPaymentRouter {
    address public steward;

    struct PaymentEvent {
        string assetType; // ETH, BTC, USDC, etc.
        string senderJurisdiction;
        string receiverJurisdiction;
        string platform;
        uint256 amountUSD;
        uint256 timestamp;
        bool verified;
    }

    PaymentEvent[] public events;

    event PaymentLogged(string assetType, string senderJurisdiction, string receiverJurisdiction, string platform, uint256 amountUSD, uint256 timestamp);
    event PaymentVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logPaymentEvent(
        string memory assetType,
        string memory senderJurisdiction,
        string memory receiverJurisdiction,
        string memory platform,
        uint256 amountUSD
    ) public {
        events.push(PaymentEvent(assetType, senderJurisdiction, receiverJurisdiction, platform, amountUSD, block.timestamp, false));
        emit PaymentLogged(assetType, senderJurisdiction, receiverJurisdiction, platform, amountUSD, block.timestamp);
    }

    function verifyPayment(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].verified = true;
        emit PaymentVerified(index, msg.sender);
    }

    function getPaymentEvent(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256, uint256, bool
    ) {
        PaymentEvent memory e = events[index];
        return (e.assetType, e.senderJurisdiction, e.receiverJurisdiction, e.platform, e.amountUSD, e.timestamp, e.verified);
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
