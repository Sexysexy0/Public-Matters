// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SniperRegistry {
    struct SniperMatch {
        string map;
        bool openLobby;
        uint256 createdAt;
    }

    struct Player {
        string name;
        uint256 rank;
        string clan;
        string flag;
    }

    SniperMatch[] public matches;
    mapping(address => Player) public players;
    mapping(uint256 => address[]) public matchPlayers; // matchId => players

    event MatchCreated(uint256 matchId, string map, bool openLobby);
    event PlayerJoined(uint256 matchId, address player);
    event RankUpdated(address player, uint256 newRank);

    function createMatch(string memory _map, bool _openLobby) external {
        matches.push(SniperMatch(_map, _openLobby, block.timestamp));
        emit MatchCreated(matches.length - 1, _map, _openLobby);
    }

    function joinMatch(uint256 _matchId) external {
        require(_matchId < matches.length, "Invalid match");
        matchPlayers[_matchId].push(msg.sender);
        emit PlayerJoined(_matchId, msg.sender);
    }

    function registerPlayer(
        string memory _name,
        uint256 _rank,
        string memory _clan,
        string memory _flag
    ) external {
        players[msg.sender] = Player(_name, _rank, _clan, _flag);
    }

    function updateRank(uint256 _newRank) external {
        players[msg.sender].rank = _newRank;
        emit RankUpdated(msg.sender, _newRank);
    }

    function getMatchPlayers(uint256 _matchId) external view returns (address[] memory) {
        return matchPlayers[_matchId];
    }
}
