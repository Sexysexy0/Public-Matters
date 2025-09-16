// SPDX-License-Identifier: HealthSanctum
pragma solidity ^0.8.19;

contract PublicHealthRevenueRouter {
    struct HealthAllocation {
        string region;
        uint256 collectedTax;
        uint256 allocatedToClinics;
        uint256 allocatedToMentalHealth;
        uint256 allocatedToEducation;
        string stewardNote;
    }

    mapping(string => HealthAllocation) public allocations;

    event RevenueTagged(string region, uint256 collectedTax);
    event AllocationActivated(string region);

    function tagRevenue(string memory region, uint256 collectedTax, uint256 clinics, uint256 mentalHealth, uint256 education, string memory stewardNote) public {
        allocations[region] = HealthAllocation(region, collectedTax, clinics, mentalHealth, education, stewardNote);
        emit RevenueTagged(region, collectedTax);
    }

    function activateAllocation(string memory region) public {
        require(allocations[region].collectedTax > 0, "No revenue tagged");
        emit AllocationActivated(region);
    }

    function getAllocationStatus(string memory region) public view returns (HealthAllocation memory) {
        return allocations[region];
    }
}
