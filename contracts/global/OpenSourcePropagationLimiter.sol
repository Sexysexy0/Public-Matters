// SPDX-License-Identifier: Propagation-License
pragma solidity ^0.8.0;

contract OpenSourcePropagationLimiter {
    address public steward;
    mapping(string => bool) public trustedRegions;

    event SyncRestricted(string region, uint timestamp);
    event SyncAllowed(string region, uint timestamp);

    constructor() {
        steward = msg.sender;
        trustedRegions["PH"] = true;
        trustedRegions["US"] = true;
        trustedRegions["EU"] = true;
    }

    function restrictSync(string memory region) public {
        require(msg.sender == steward, "Only steward can restrict");
        trustedRegions[region] = false;
        emit SyncRestricted(region, block.timestamp);
    }

    function allowSync(string memory region) public {
        require(msg.sender == steward, "Only steward can allow");
        trustedRegions[region] = true;
        emit SyncAllowed(region, block.timestamp);
    }

    function isSyncAllowed(string memory region) public view returns (bool) {
        return trustedRegions[region];
    }
}
