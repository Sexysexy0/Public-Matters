// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEventBoard {
    function postEvent(string memory _title, string memory _description) external;
}

contract ZombieModeRegistry {
    struct ZombieMatch {
        uint256 id;
        uint256 players;
        uint256 rounds;
        bool active;
    }

    enum ZombieType { Tank, Spitter, Runner, Stealth }

    mapping(uint256 => ZombieMatch) public matches;
    mapping(address => ZombieType) public infected;
    uint256 public matchCount;

    IEventBoard public eventBoard;
    address public owner;

    event MatchCreated(uint256 id, uint256 players, uint256 rounds);
    event PlayerInfected(address player, ZombieType zombieType);
    event MatchFinished(uint256 id);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor(address _eventBoard) {
        owner = msg.sender;
        eventBoard = IEventBoard(_eventBoard);
    }

    function createZombieMatch(uint256 _players, uint256 _rounds) external onlyOwner {
        require(_players == 30 || _players == 20 || _players == 10, "invalid player count");
        require(_rounds == 3 || _rounds == 5 || _rounds == 10, "invalid rounds");
        matches[matchCount] = ZombieMatch(matchCount, _players, _rounds, true);
        emit MatchCreated(matchCount, _players, _rounds);
        eventBoard.postEvent("Zombie Match Created", string(abi.encodePacked("Players: ", uintToString(_players), ", Rounds: ", uintToString(_rounds))));
        matchCount++;
    }

    function infectPlayer(address _player) external onlyOwner {
        require(matchCount > 0, "no match");
        ZombieType zType = ZombieType(uint256(keccak256(abi.encodePacked(block.timestamp, _player))) % 4);
        infected[_player] = zType;
        emit PlayerInfected(_player, zType);
        eventBoard.postEvent("Player Infected", string(abi.encodePacked("Zombie type assigned")));
    }

    function finishMatch(uint256 _id) external onlyOwner {
        require(matches[_id].active, "match not active");
        matches[_id].active = false;
        emit MatchFinished(_id);
        eventBoard.postEvent("Zombie Match Finished", string(abi.encodePacked("Match #", uintToString(_id), " finished")));
    }

    function uintToString(uint256 v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint256 j = v;
        uint256 length;
        while (j != 0) { length++; j /= 10; }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = v;
        while (j != 0) { bstr[--k] = bytes1(uint8(48 + j % 10)); j /= 10; }
        return string(bstr);
    }
}
