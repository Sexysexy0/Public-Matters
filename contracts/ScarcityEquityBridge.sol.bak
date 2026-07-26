// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ScarcityEquityBridge {
    struct ScarcityEquity {
        address steward;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    ScarcityEquity[] public scarcities;

    event ScarcityEquityLogged(address indexed steward, string context, string safeguard);
    event ScarcityEquitySafeguarded(uint256 indexed id, address verifier);

    function logScarcityEquity(string memory _context, string memory _safeguard) public {
        scarcities.push(ScarcityEquity(msg.sender, _context, _safeguard, block.timestamp, false));
        emit ScarcityEquityLogged(msg.sender, _context, _safeguard);
    }

    function safeguardScarcityEquity(uint256 _id) public {
        require(_id < scarcities.length, "Invalid ID");
        scarcities[_id].safeguarded = true;
        emit ScarcityEquitySafeguarded(_id, msg.sender);
    }

    function getScarcityEquity(uint256 _id) public view returns (ScarcityEquity memory) {
        require(_id < scarcities.length, "Invalid ID");
        return scarcities[_id];
    }

    function totalScarcities() public view returns (uint256) {
        return scarcities.length;
    }
}
