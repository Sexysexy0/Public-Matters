// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ProductAccessFilter {
    address public steward;
    mapping(string => bool) public regionAccess;

    event RegionBlocked(string region);
    event RegionAllowed(string region);

    constructor() {
        steward = msg.sender;
        regionAccess["China"] = false;
        regionAccess["Russia"] = false;
        regionAccess["India"] = true;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function blockRegion(string memory region) public onlySteward {
        regionAccess[region] = false;
        emit RegionBlocked(region);
    }

    function allowRegion(string memory region) public onlySteward {
        regionAccess[region] = true;
        emit RegionAllowed(region);
    }

    function canAccess(string memory region) public view returns (bool) {
        return regionAccess[region];
    }
}
