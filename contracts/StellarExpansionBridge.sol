// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StellarExpansionBridge {
    struct Expansion {
        address studio;
        string title;
        string platform;
        uint256 timestamp;
        bool safeguarded;
    }

    Expansion[] public expansions;

    event ExpansionLogged(address indexed studio, string title, string platform);
    event ExpansionSafeguarded(uint256 indexed id, address verifier);

    function logExpansion(string memory _title, string memory _platform) public {
        expansions.push(Expansion(msg.sender, _title, _platform, block.timestamp, false));
        emit ExpansionLogged(msg.sender, _title, _platform);
    }

    function safeguardExpansion(uint256 _id) public {
        require(_id < expansions.length, "Invalid ID");
        expansions[_id].safeguarded = true;
        emit ExpansionSafeguarded(_id, msg.sender);
    }

    function getExpansion(uint256 _id) public view returns (Expansion memory) {
        require(_id < expansions.length, "Invalid ID");
        return expansions[_id];
    }

    function totalExpansions() public view returns (uint256) {
        return expansions.length;
    }
}
