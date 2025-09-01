// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumRentalRegistry {
    struct RentalUnit {
        string unitID;
        string barangay;
        string tenantName;
        uint256 monthlyRent;
        string emotionalTag; // "DamayClause", "AuditGlow", "SanctumGlow"
        bool isOccupied;
        uint256 timestamp;
    }

    RentalUnit[] public rentals;

    function logRental(string memory unitID, string memory barangay, string memory tenantName, uint256 monthlyRent, string memory emotionalTag, bool isOccupied) public {
        rentals.push(RentalUnit(unitID, barangay, tenantName, monthlyRent, emotionalTag, isOccupied, block.timestamp));
    }

    function totalRentals() public view returns (uint256) {
        return rentals.length;
    }
}
