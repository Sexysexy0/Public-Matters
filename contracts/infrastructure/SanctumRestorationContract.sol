// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract SanctumRestorationContract {
    struct Sanctum {
        string name;
        string location;
        bool restored;
    }

    mapping(uint => Sanctum) public sanctums;
    uint public sanctumCount;

    event SanctumRestored(string name, string location);

    function restoreSanctum(string memory name, string memory location) public {
        sanctums[sanctumCount++] = Sanctum(name, location, true);
        emit SanctumRestored(name, location);
    }
}
