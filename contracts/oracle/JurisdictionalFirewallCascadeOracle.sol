// SPDX-License-Identifier: FirewallCascade-License
pragma solidity ^0.8.0;

contract JurisdictionalFirewallCascadeOracle {
    address public steward;
    mapping(string => bool) public isBlocked;
    mapping(string => uint256) public blockLevel;

    event JurisdictionBlocked(string countryCode, uint256 level, uint timestamp);
    event FirewallPulseEmitted(string countryCode, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blockJurisdiction(string memory countryCode, uint256 level) public {
        require(msg.sender == steward, "Only steward can block");
        isBlocked[countryCode] = true;
        blockLevel[countryCode] = level;
        emit JurisdictionBlocked(countryCode, level, block.timestamp);
        emit FirewallPulseEmitted(countryCode, block.timestamp);
    }

    function isJurisdictionBlocked(string memory countryCode) public view returns (bool) {
        return isBlocked[countryCode];
    }

    function getBlockLevel(string memory countryCode) public view returns (uint256) {
        return blockLevel[countryCode];
    }
}
