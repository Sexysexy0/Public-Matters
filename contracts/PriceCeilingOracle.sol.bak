// PriceCeilingOracle.sol
pragma solidity ^0.8.0;

contract PriceCeilingOracle {
    uint256 public constant MAX_PRICE = 70;
    
    struct GasStation {
        string name;
        uint256 currentPrice;
        bool compliant;
    }

    mapping(address => GasStation) public stations;

    function updatePrice(uint256 _newPrice) public {
        bool status = (_newPrice <= MAX_PRICE);
        stations[msg.sender] = GasStation("Station_ID", _newPrice, status);
    }
}
