// SPDX-License-Identifier: Firewall-License
pragma solidity ^0.8.0;

contract SovereignSanctumFirewall {
    address public steward;
    string[] public blockedJurisdictions = ["CN", "RU", "IN"];
    mapping(string => bool) public isBlocked;

    event JurisdictionBlocked(string countryCode, uint timestamp);

    constructor() {
        steward = msg.sender;
        for (uint i = 0; i < blockedJurisdictions.length; i++) {
            isBlocked[blockedJurisdictions[i]] = true;
        }
    }

    function blockJurisdiction(string memory countryCode) public {
        require(msg.sender == steward, "Only steward can block");
        isBlocked[countryCode] = true;
        emit JurisdictionBlocked(countryCode, block.timestamp);
    }

    function isJurisdictionBlocked(string memory countryCode) public view returns (bool) {
        return isBlocked[countryCode];
    }
}
