// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RegionalBudgetSync {
    struct LGUAllocation {
        string region;
        string province;
        string municipality;
        uint256 amount;
        string program;
        string emotionalTag; // e.g. "AuditGlow", "DamayClause", "ResilienceSurge"
    }

    LGUAllocation[] public allocations;

    event AllocationLogged(string region, string municipality, uint256 amount, string emotionalTag);

    function logAllocation(
        string memory _region,
        string memory _province,
        string memory _municipality,
        uint256 _amount,
        string memory _program,
        string memory _emotionalTag
    ) public {
        allocations.push(LGUAllocation(_region, _province, _municipality, _amount, _program, _emotionalTag));
        emit AllocationLogged(_region, _municipality, _amount, _emotionalTag);
    }

    function getAllocation(uint256 index) public view returns (LGUAllocation memory) {
        return allocations[index];
    }

    function totalAllocations() public view returns (uint256) {
        return allocations.length;
    }
}
