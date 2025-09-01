// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract NegotiationProtocol {
    struct Offer {
        address buyer;
        uint256 proposedPrice;
        string planType;
        string emotionalAPR;
        bool accepted;
    }

    address public steward;
    uint256 public basePrice;
    Offer[] public offers;

    event OfferSubmitted(address indexed buyer, uint256 price, string planType, string emotionalAPR);
    event OfferAccepted(address indexed buyer, uint256 finalPrice);

    constructor(uint256 _basePrice) {
        steward = msg.sender;
        basePrice = _basePrice;
    }

    function submitOffer(uint256 _price, string memory _planType, string memory _emotionalAPR) public {
        offers.push(Offer(msg.sender, _price, _planType, _emotionalAPR, false));
        emit OfferSubmitted(msg.sender, _price, _planType, _emotionalAPR);
    }

    function acceptOffer(uint256 index) public {
        require(msg.sender == steward, "Only steward may accept");
        offers[index].accepted = true;
        emit OfferAccepted(offers[index].buyer, offers[index].proposedPrice);
    }

    function getOfferCount() public view returns (uint256) {
        return offers.length;
    }
}
