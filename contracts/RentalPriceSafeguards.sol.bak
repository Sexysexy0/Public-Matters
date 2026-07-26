// RentalPriceSafeguards.sol
pragma solidity ^0.8.0;

contract RentalPriceSafeguards {
    struct RentalUnit {
        uint256 currentRent;
        uint256 lastIncreaseDate;
        uint256 maxIncreaseRate; // e.g., 500 = 5%
    }

    mapping(uint256 => RentalUnit) public registry;

    function applyInflationAdjustment(uint256 _unitId, uint256 _cpiRate) public {
        RentalUnit storage unit = registry[_unitId];
        // Ensure at least 12 months have passed before increase
        require(block.timestamp >= unit.lastIncreaseDate + 365 days, "Increase not allowed yet");
        
        uint256 allowedRate = _cpiRate > unit.maxIncreaseRate ? unit.maxIncreaseRate : _cpiRate;
        unit.currentRent += (unit.currentRent * allowedRate) / 10000;
        unit.lastIncreaseDate = block.timestamp;
    }
}
