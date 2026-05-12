// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StellarBladeOracle {
    struct Rumor {
        address source;
        string title;
        string context;
        uint256 timestamp;
        bool safeguarded;
    }

    Rumor[] public rumors;

    event RumorLogged(address indexed source, string title, string context);
    event RumorSafeguarded(uint256 indexed id, address verifier);

    function logRumor(string memory _title, string memory _context) public {
        rumors.push(Rumor(msg.sender, _title, _context, block.timestamp, false));
        emit RumorLogged(msg.sender, _title, _context);
    }

    function safeguardRumor(uint256 _id) public {
        require(_id < rumors.length, "Invalid ID");
        rumors[_id].safeguarded = true;
        emit RumorSafeguarded(_id, msg.sender);
    }

    function getRumor(uint256 _id) public view returns (Rumor memory) {
        require(_id < rumors.length, "Invalid ID");
        return rumors[_id];
    }

    function totalRumors() public view returns (uint256) {
        return rumors.length;
    }
}
