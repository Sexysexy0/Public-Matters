// MedicinePriceSafeguards.sol
pragma solidity ^0.8.0;

contract MedicinePriceSafeguards {
    struct Medicine {
        string name;
        uint256 baseCost;
        uint256 maxPriceCeiling;
        bool isEssential;
    }

    mapping(string => Medicine) public catalog;

    event PriceViolation(string medicine, uint256 reportedPrice, address store);

    function updatePriceCeiling(string memory _name, uint256 _base, uint256 _markup) public {
        // Ceiling calculation: Base Cost + Allowable Markup (e.g. 15%)
        uint256 ceiling = _base + (_base * _markup / 100);
        catalog[_name] = Medicine(_name, _base, ceiling, true);
    }

    function reportPharmacy(string memory _name, uint256 _actualPrice) public {
        if (_actualPrice > catalog[_name].maxPriceCeiling) {
            emit PriceViolation(_name, _actualPrice, msg.sender);
        }
    }
}
