// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketMarineTradeDeck {
    struct TradeOffer {
        string country;
        string species;
        uint quantityKg;
        uint pricePerKg;
        bool accepted;
    }

    mapping(uint => TradeOffer) public offers;
    uint public offerCount;

    function createOffer(string memory country, string memory species, uint quantityKg, uint pricePerKg) public {
        offers[offerCount++] = TradeOffer(country, species, quantityKg, pricePerKg, false);
    }

    function acceptOffer(uint offerId) public {
        offers[offerId].accepted = true;
    }
}
