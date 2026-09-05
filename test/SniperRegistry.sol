// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SniperRegistry {
    struct SniperMatch {
        string map;
        bool openLobby;
        uint256 createdAt;
        string server;
    }

    struct Player {
        string name;
        uint256 rank;
        string clan;
        string flag;
        uint256 ping;
        string badge;
    }

    SniperMatch[] public matches;
    mapping(address => Player) public players;
    mapping(uint256 => address[]) public matchPlayers;

    event MatchCreated(uint256 matchId, string map, bool openLobby, string server);
    event PlayerJoined(uint256 matchId, address player);
    event RankUpdated(address player, uint256 newRank);
    event PingChecked(address player, uint256 ping);
    event BadgeAssigned(address player, string badge);

    function createMatch(string memory _map, bool _openLobby, string memory _server) external {
        matches.push(SniperMatch(_map, _openLobby, block.timestamp, _server));
        emit MatchCreated(matches.length - 1, _map, _openLobby, _server);
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
        players[msg.sender] = Player(_name, _rank, _clan, _flag, 0, "");
    }

    function updateRank(uint256 _newRank) external {
        players[msg.sender].rank = _newRank;
        emit RankUpdated(msg.sender, _newRank);
    }

    function checkPing(uint256 _ping) external {
        players[msg.sender].ping = _ping;
        emit PingChecked(msg.sender, _ping);
    }

    function assignBadge(string memory _badge) external {
        players[msg.sender].badge = _badge;
        emit BadgeAssigned(msg.sender, _badge);
    }

    function getMatchPlayers(uint256 _matchId) external view returns (address[] memory) {
        return matchPlayers[_matchId];
    }
}
