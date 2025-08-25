// SPDX-License-Identifier: Mythic-Remembrance
pragma solidity ^0.8.25;

contract MemorySanctumProtocol {
    struct Sanctum {
        string name;
        string location;
        string memoryType; // e.g. Holocaust, Ancestral, Civic
        bool protected;
        string steward;
    }

    Sanctum[] public sanctums;

    function registerSanctum(
        string memory name,
        string memory location,
        string memory memoryType,
        string memory steward
    ) public {
        sanctums.push(Sanctum(name, location, memoryType, true, steward));
    }

    function toggleProtection(uint index, bool status) public {
        sanctums[index].protected = status;
    }

    function getSanctum(uint index) public view returns (Sanctum memory) {
        return sanctums[index];
    }
}
