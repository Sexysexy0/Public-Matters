// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.27;

contract TerritoryDefenseClause {
    address public steward;
    mapping(string => bool) public defenseTagged;
    mapping(string => string) public dignityNotes;

    event DefenseActivated(string territory, string dignityNote);
    event OverrideLogged(string territory, string timestamp);

    constructor() {
        steward = msg.sender;
    }

    function activateDefense(string memory territory, string memory dignityNote) public {
        require(msg.sender == steward, "Unauthorized steward");
        defenseTagged[territory] = true;
        dignityNotes[territory] = dignityNote;
        emit DefenseActivated(territory, dignityNote);
    }

    function logOverride(string memory territory, string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        emit OverrideLogged(territory, timestamp);
    }

    function isDefenseActive(string memory territory) public view returns (bool) {
        return defenseTagged[territory];
    }

    function getDignityNote(string memory territory) public view returns (string memory) {
        return dignityNotes[territory];
    }
}
