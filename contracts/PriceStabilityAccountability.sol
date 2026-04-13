// PriceStabilityAccountability.sol
pragma solidity ^0.8.0;

contract PriceStabilityAccountability {
    struct PricePact {
        string commodity;
        uint256 agreedPrice;
        uint256 lastVerified;
    }

    mapping(address => mapping(string => PricePact)) public memberPrices;

    event PriceDeviationFlagged(address member, string item, uint256 price);

    function reportPrice(string memory _item, uint256 _price, uint256 _marketAverage) public {
        // Flag if price is 15% higher than the community-agreed average
        if (_price > (_marketAverage * 115 / 100)) {
            emit PriceDeviationFlagged(msg.sender, _item, _price);
        }
        memberPrices[msg.sender][_item] = PricePact(_item, _price, block.timestamp);
    }
}
