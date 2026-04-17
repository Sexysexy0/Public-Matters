// RentControlAutomator.sol
pragma solidity ^0.8.0;

contract RentControlAutomator {
    uint256 public constant MAX_INCREASE_PERCENT = 3; // 3% max annual increase
    
    struct Lease {
        uint256 currentRent;
        uint256 lastUpdated;
        bool isProtected;
    }

    mapping(uint256 => Lease) public properties;

    function updateRent(uint256 propertyId, uint256 newRent) public {
        uint256 oldRent = properties[propertyId].currentRent;
        require(newRent <= oldRent + (oldRent * MAX_INCREASE_PERCENT / 100), "Rent increase exceeds legal limit!");
        
        properties[propertyId].currentRent = newRent;
        properties[propertyId].lastUpdated = block.timestamp;
    }
}
