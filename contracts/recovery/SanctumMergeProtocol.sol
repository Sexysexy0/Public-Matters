// SPDX-License-Identifier: Mythic-Fusion
pragma solidity ^0.8.25;

contract SanctumMergeProtocol {
    struct Sanctum {
        string name;
        string steward;
        string faith; // Jewish, Muslim, Civic, Ancestral, Hybrid
        string location;
        string emotionalAPR;
        bool active;
    }

    Sanctum[] public sanctums;

    event SanctumMerged(
        string nameA,
        string nameB,
        string mergedName,
        string steward,
        string emotionalAPR,
        uint256 timestamp
    );

    function registerSanctum(
        string memory name,
        string memory steward,
        string memory faith,
        string memory location,
        string memory emotionalAPR
    ) public {
        sanctums.push(Sanctum(name, steward, faith, location, emotionalAPR, true));
    }

    function mergeSanctums(uint indexA, uint indexB, string memory mergedName) public {
        require(sanctums[indexA].active && sanctums[indexB].active, "Sanctums must be active");

        string memory steward = sanctums[indexA].steward;
        string memory emotionalAPR = sanctums[indexA].emotionalAPR;

        sanctums[indexA].active = false;
        sanctums[indexB].active = false;

        sanctums.push(Sanctum(
            mergedName,
            steward,
            "Hybrid",
            "Merged Zone",
            emotionalAPR,
            true
        ));

        emit SanctumMerged(
            sanctums[indexA].name,
            sanctums[indexB].name,
            mergedName,
            steward,
            emotionalAPR,
            block.timestamp
        );
    }

    function getSanctum(uint index) public view returns (Sanctum memory) {
        return sanctums[index];
    }

    function totalSanctums() public view returns (uint) {
        return sanctums.length;
    }
}
