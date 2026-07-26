// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EquityExpansionVault {
    struct Expansion {
        address overseer;
        string title;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Expansion[] public expansions;

    event ExpansionLogged(address indexed overseer, string title, string safeguard);
    event ExpansionSafeguarded(uint256 indexed id, address verifier);

    function logExpansion(string memory _title, string memory _safeguard) public {
        expansions.push(Expansion(msg.sender, _title, _safeguard, block.timestamp, false));
        emit ExpansionLogged(msg.sender, _title, _safeguard);
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
