// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LegacyEquityOracle {
    struct LegacyRequest {
        address player;
        string title;
        uint256 timestamp;
        bool safeguarded;
    }

    LegacyRequest[] public requests;

    event LegacyLogged(address indexed player, string title);
    event LegacySafeguarded(uint256 indexed id, address verifier);

    function logLegacy(string memory _title) public {
        requests.push(LegacyRequest(msg.sender, _title, block.timestamp, false));
        emit LegacyLogged(msg.sender, _title);
    }

    function safeguardLegacy(uint256 _id) public {
        require(_id < requests.length, "Invalid ID");
        requests[_id].safeguarded = true;
        emit LegacySafeguarded(_id, msg.sender);
    }

    function getLegacy(uint256 _id) public view returns (LegacyRequest memory) {
        require(_id < requests.length, "Invalid ID");
        return requests[_id];
    }

    function totalLegacies() public view returns (uint256) {
        return requests.length;
    }
}
