// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityContinuityVault {
    struct Continuity {
        address fan;
        string title;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Continuity[] public continuities;

    event ContinuityLogged(address indexed fan, string title, string safeguard);
    event ContinuitySafeguarded(uint256 indexed id, address verifier);

    function logContinuity(string memory _title, string memory _safeguard) public {
        continuities.push(Continuity(msg.sender, _title, _safeguard, block.timestamp, false));
        emit ContinuityLogged(msg.sender, _title, _safeguard);
    }

    function safeguardContinuity(uint256 _id) public {
        require(_id < continuities.length, "Invalid ID");
        continuities[_id].safeguarded = true;
        emit ContinuitySafeguarded(_id, msg.sender);
    }

    function getContinuity(uint256 _id) public view returns (Continuity memory) {
        require(_id < continuities.length, "Invalid ID");
        return continuities[_id];
    }

    function totalContinuities() public view returns (uint256) {
        return continuities.length;
    }
}
