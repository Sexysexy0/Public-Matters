// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DarkKnightAccessShield {
    struct AccessIncident {
        address player;
        string title;
        string issue;
        uint256 timestamp;
        bool safeguarded;
    }

    AccessIncident[] public incidents;

    event AccessLogged(address indexed player, string title, string issue);
    event AccessSafeguarded(uint256 indexed id, address verifier);

    function logAccess(string memory _title, string memory _issue) public {
        incidents.push(AccessIncident(msg.sender, _title, _issue, block.timestamp, false));
        emit AccessLogged(msg.sender, _title, _issue);
    }

    function safeguardAccess(uint256 _id) public {
        require(_id < incidents.length, "Invalid ID");
        incidents[_id].safeguarded = true;
        emit AccessSafeguarded(_id, msg.sender);
    }

    function getAccess(uint256 _id) public view returns (AccessIncident memory) {
        require(_id < incidents.length, "Invalid ID");
        return incidents[_id];
    }

    function totalIncidents() public view returns (uint256) {
        return incidents.length;
    }
}
