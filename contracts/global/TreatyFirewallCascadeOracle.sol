// SPDX-License-Identifier: Treaty-License
pragma solidity ^0.8.0;

contract TreatyFirewallCascadeOracle {
    address public steward;
    mapping(string => bool) public rogueJurisdictions;
    mapping(string => uint256) public sanctionLevel;

    event SanctionEmitted(string jurisdiction, uint256 level, uint timestamp);
    event JurisdictionContained(string jurisdiction, uint timestamp);

    constructor() {
        steward = msg.sender;
        rogueJurisdictions["IR"] = true;
        rogueJurisdictions["RU"] = true;
    }

    function emitSanction(string memory jurisdiction, uint256 level) public {
        require(msg.sender == steward, "Only steward can emit");
        sanctionLevel[jurisdiction] = level;
        emit SanctionEmitted(jurisdiction, level, block.timestamp);
    }

    function containJurisdiction(string memory jurisdiction) public {
        require(msg.sender == steward, "Only steward can contain");
        rogueJurisdictions[jurisdiction] = true;
        emit JurisdictionContained(jurisdiction, block.timestamp);
    }

    function isContained(string memory jurisdiction) public view returns (bool) {
        return rogueJurisdictions[jurisdiction];
    }

    function getSanctionLevel(string memory jurisdiction) public view returns (uint256) {
        return sanctionLevel[jurisdiction];
    }
}
