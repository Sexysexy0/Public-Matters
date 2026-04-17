// EnergyPriceAnchor.sol
pragma solidity ^0.8.0;

contract EnergyPriceAnchor {
    uint256 public globalOilPrice; // Galing sa Energy Oracle
    uint256 public transportFareCap;

    function syncOilPrice(uint256 _price) public {
        globalOilPrice = _price;
        // Formula: Kung oil < $85, i-lock ang fare sa minimum rate
        if (_price <= 83) {
            transportFareCap = 12; // Halimbawa: 12 pesos base fare
        }
    }
}
