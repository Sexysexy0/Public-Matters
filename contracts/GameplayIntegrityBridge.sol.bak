// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GameplayIntegrityBridge {
    struct Gameplay {
        address steward;
        string title;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Gameplay[] public gameplays;

    event GameplayLogged(address indexed steward, string title, string safeguard);
    event GameplaySafeguarded(uint256 indexed id, address verifier);

    function logGameplay(string memory _title, string memory _safeguard) public {
        gameplays.push(Gameplay(msg.sender, _title, _safeguard, block.timestamp, false));
        emit GameplayLogged(msg.sender, _title, _safeguard);
    }

    function safeguardGameplay(uint256 _id) public {
        require(_id < gameplays.length, "Invalid ID");
        gameplays[_id].safeguarded = true;
        emit GameplaySafeguarded(_id, msg.sender);
    }

    function getGameplay(uint256 _id) public view returns (Gameplay memory) {
        require(_id < gameplays.length, "Invalid ID");
        return gameplays[_id];
    }

    function totalGameplays() public view returns (uint256) {
        return gameplays.length;
    }
}
