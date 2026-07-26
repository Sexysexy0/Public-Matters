// ResourcePricingAccountability.sol
pragma solidity ^0.8.0;

contract ResourcePricingAccountability {
    struct Material {
        string title;
        uint256 maxFairPrice;
        bool isSanctioned;
    }

    mapping(string => Material) public priceIndex;

    function setFairPrice(string memory _title, uint256 _price) public {
        priceIndex[_title] = Material(_title, _price, false);
    }

    function checkPriceCompliance(string memory _title, uint256 _quotedPrice) public returns (bool) {
        if (_quotedPrice > priceIndex[_title].maxFairPrice) {
            priceIndex[_title].isSanctioned = true; // Flag store or item
            return false;
        }
        return true;
    }
}
