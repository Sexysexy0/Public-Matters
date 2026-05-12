// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AuthenticityContinuityBridge {
    struct Authenticity {
        address steward;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Authenticity[] public authenticities;

    event AuthenticityLogged(address indexed steward, string context, string safeguard);
    event AuthenticitySafeguarded(uint256 indexed id, address verifier);

    function logAuthenticity(string memory _context, string memory _safeguard) public {
        authenticities.push(Authenticity(msg.sender, _context, _safeguard, block.timestamp, false));
        emit AuthenticityLogged(msg.sender, _context, _safeguard);
    }

    function safeguardAuthenticity(uint256 _id) public {
        require(_id < authenticities.length, "Invalid ID");
        authenticities[_id].safeguarded = true;
        emit AuthenticitySafeguarded(_id, msg.sender);
    }

    function getAuthenticity(uint256 _id) public view returns (Authenticity memory) {
        require(_id < authenticities.length, "Invalid ID");
        return authenticities[_id];
    }

    function totalAuthenticities() public view returns (uint256) {
        return authenticities.length;
    }
}
