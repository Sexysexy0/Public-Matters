// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AccessHubRegistry: record proximity of relocation sites to essential hubs
contract AccessHubRegistry {
    struct HubAccess {
        uint256 id;
        string site;
        string hub;        // "Market", "Hospital", "Jobs Center"
        uint256 distanceKm;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => HubAccess) public hubs;
    mapping(address => bool) public stewards;

    event HubLogged(uint256 indexed id, string site, string hub, uint256 distanceKm);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logHub(string calldata site, string calldata hub, uint256 distanceKm) external {
        require(stewards[msg.sender], "Only steward");
        hubs[nextId] = HubAccess(nextId, site, hub, distanceKm, block.timestamp);
        emit HubLogged(nextId, site, hub, distanceKm);
        nextId++;
    }
}
