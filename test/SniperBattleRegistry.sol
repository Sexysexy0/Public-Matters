// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEventBoard {
    function postEvent(string memory _title, string memory _description) external;
}

contract SniperBattleRegistry {
    struct SniperMatch {
        string map;
        bool openLobby;
        uint256 createdAt;
        string server;
        uint8 maxPlayers;
    }

    struct Player {
        string name;
        uint256 rank;
        string clan;
        string flag;
        uint256 ping;
        string badge;
        bool registered;
    }

    SniperMatch[] public matches;
    mapping(address => Player) public players;
    mapping(uint256 => address[]) public matchPlayers;
    mapping(string => bool) public allowedMaps;

    IEventBoard public eventBoard;
    address public owner;

    event MatchCreated(uint256 matchId, string map, bool openLobby, string server, uint8 maxPlayers);
    event PlayerJoined(uint256 matchId, address player);
    event PlayerLeft(uint256 matchId, address player);
    event RankUpdated(address player, uint256 newRank);
    event PingChecked(address player, uint256 ping);
    event BadgeAssigned(address player, string badge);
    event ClanFlagUpdated(address player, string clan, string flag);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor(address _eventBoard, string[] memory _maps) {
        owner = msg.sender;
        eventBoard = IEventBoard(_eventBoard);
        for (uint i = 0; i < _maps.length; i++) {
            allowedMaps[_maps[i]] = true;
        }
    }

    // Admin: add allowed sniper map
    function addMap(string memory _map) external onlyOwner {
        allowedMaps[_map] = true;
    }

    // Create a sniper match; openLobby true allows auto‑fill
    function createMatch(
        string memory _map,
        bool _openLobby,
        string memory _server,
        uint8 _maxPlayers
    ) external {
        require(allowedMaps[_map], "map not allowed");
        matches.push(SniperMatch(_map, _openLobby, block.timestamp, _server, _maxPlayers));
        uint256 id = matches.length - 1;
        emit MatchCreated(id, _map, _openLobby, _server, _maxPlayers);
        eventBoard.postEvent("Sniper Match Created", string(abi.encodePacked("Map: ", _map, ", Server: ", _server)));
    }

    // Join match; if openLobby and slot available, allow join even if someone left
    function joinMatch(uint256 _matchId) external {
        require(_matchId < matches.length, "invalid match");
        SniperMatch storage m = matches[_matchId];
        require(matchPlayers[_matchId].length < m.maxPlayers, "match full");
        matchPlayers[_matchId].push(msg.sender);
        emit PlayerJoined(_matchId, msg.sender);
    }

    // Leave match (so openLobby can accept replacements)
    function leaveMatch(uint256 _matchId) external {
        require(_matchId < matches.length, "invalid match");
        address[] storage list = matchPlayers[_matchId];
        for (uint i = 0; i < list.length; i++) {
            if (list[i] == msg.sender) {
                list[i] = list[list.length - 1];
                list.pop();
                emit PlayerLeft(_matchId, msg.sender);
                return;
            }
        }
        revert("not in match");
    }

    // Player registration and profile
    function registerPlayer(
        string memory _name,
        uint256 _rank,
        string memory _clan,
        string memory _flag
    ) external {
        players[msg.sender] = Player(_name, _rank, _clan, _flag, 0, "", true);
        emit ClanFlagUpdated(msg.sender, _clan, _flag);
        eventBoard.postEvent("Player Registered", string(abi.encodePacked(_name, " joined with clan ", _clan)));
    }

    function updateRank(uint256 _newRank) external {
        require(players[msg.sender].registered, "not registered");
        players[msg.sender].rank = _newRank;
        emit RankUpdated(msg.sender, _newRank);
        eventBoard.postEvent("Rank Update", string(abi.encodePacked(players[msg.sender].name, " new rank: ", uintToString(_newRank))));
    }

    function checkPing(uint256 _ping) external {
        require(players[msg.sender].registered, "not registered");
        players[msg.sender].ping = _ping;
        emit PingChecked(msg.sender, _ping);
    }

    function assignBadge(string memory _badge) external {
        require(players[msg.sender].registered, "not registered");
        players[msg.sender].badge = _badge;
        emit BadgeAssigned(msg.sender, _badge);
        eventBoard.postEvent("Badge Assigned", string(abi.encodePacked(players[msg.sender].name, " earned badge: ", _badge)));
    }

    function updateClanFlag(string memory _clan, string memory _flag) external {
        require(players[msg.sender].registered, "not registered");
        players[msg.sender].clan = _clan;
        players[msg.sender].flag = _flag;
        emit ClanFlagUpdated(msg.sender, _clan, _flag);
        eventBoard.postEvent("Clan Update", string(abi.encodePacked(players[msg.sender].name, " now in clan ", _clan)));
    }

    // View players in a match
    function getMatchPlayers(uint256 _matchId) external view returns (address[] memory) {
        return matchPlayers[_matchId];
    }

    // Utility
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
