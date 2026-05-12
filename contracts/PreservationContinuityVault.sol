// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PreservationContinuityVault {
    struct LegacyTitle {
        address player;
        string game;
        uint256 timestamp;
        bool safeguarded;
    }

    LegacyTitle[] public titles;

    event TitleLogged(address indexed player, string game);
    event TitleSafeguarded(uint256 indexed id, address verifier);

    function logTitle(string memory _game) public {
        titles.push(LegacyTitle(msg.sender, _game, block.timestamp, false));
        emit TitleLogged(msg.sender, _game);
    }

    function safeguardTitle(uint256 _id) public {
        require(_id < titles.length, "Invalid ID");
        titles[_id].safeguarded = true;
        emit TitleSafeguarded(_id, msg.sender);
    }

    function getTitle(uint256 _id) public view returns (LegacyTitle memory) {
        require(_id < titles.length, "Invalid ID");
        return titles[_id];
    }

    function totalTitles() public view returns (uint256) {
        return titles.length;
    }
}
