// FoodSecuritySafeguards.sol
pragma solidity ^0.8.0;

contract FoodSecuritySafeguards {
    struct Commodity {
        string name;
        uint256 currentStock;
        uint256 emergencyReserveLimit; 
        bool exportRestricted;
    }

    mapping(string => Commodity) public inventory;

    event SecurityAlert(string commodity, string status);

    function updateStock(string memory _name, uint256 _stock, uint256 _limit) public {
        bool restricted = _stock <= _limit;
        inventory[_name] = Commodity(_name, _stock, _limit, restricted);
        
        if (restricted) {
            emit SecurityAlert(_name, "CRITICAL: Stock below reserve limit. Export restricted.");
        }
    }
}
