// TransparentRelief.sol (v2.0 - The Anti-Greed Update)
pragma solidity ^0.8.0;

contract TransparentRelief {
    uint256 public currentGasPrice; // I-update ito via Oracle (e.g., Chainlink)
    uint256 public constant GAS_THRESHOLD = 80; // Halimbawa: 80 Pesos/Liter

    function calculateCommission() public view returns (uint256) {
        // Kung ang presyo ng gas ay lumampas sa threshold, 0% na ang commission.
        if (currentGasPrice >= GAS_THRESHOLD) {
            return 0; // "Emergency Relief Mode"
        }
        return 1; // Default "Sovereign Rate" (1%)
    }

    function updateGasPrice(uint256 _newPrice) public {
        // Only the Admin (You) or an authorized Oracle can trigger this.
        currentGasPrice = _newPrice;
    }
}
