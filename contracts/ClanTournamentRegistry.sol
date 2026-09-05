// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEventBoard {
    function postEvent(string memory _title, string memory _description) external;
}

contract ClanTournamentRegistry {
    struct Clan {
        string name;
        string flag;
        address leader;
        uint256 members;
    }

    struct War {
        uint256 id;
        string clanA;
        string clanB;
        uint256 startedAt;
        bool active;
    }

    struct Tournament {
        uint256 id;
        string name;
        string[] participants;
        uint256 round;
        bool finished;
    }

    mapping(string => Clan) public clans;
    War[] public wars;
    Tournament[] public tournaments;

    IEventBoard public eventBoard;
    address public owner;

    event ClanCreated(string name, string flag, address leader);
    event WarDeclared(uint256 id, string clanA, string clanB);
    event WarEnded(uint256 id);
    event TournamentCreated(uint256 id, string name);
    event TournamentAdvanced(uint256 id, uint256 round);
    event TournamentFinished(uint256 id, string winner);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor(address _eventBoard) {
        owner = msg.sender;
        eventBoard = IEventBoard(_eventBoard);
    }

    function createClan(string memory _name, string memory _flag) external {
        require(clans[_name].leader == address(0), "clan exists");
        clans[_name] = Clan(_name, _flag, msg.sender, 1);
        emit ClanCreated(_name, _flag, msg.sender);
        eventBoard.postEvent("Clan Created", string(abi.encodePacked(_name, " with flag ", _flag)));
    }

    function declareWar(string memory _clanA, string memory _clanB) external onlyOwner {
        wars.push(War(wars.length, _clanA, _clanB, block.timestamp, true));
        emit WarDeclared(wars.length - 1, _clanA, _clanB);
        eventBoard.postEvent("Clan War Declared", string(abi.encodePacked(_clanA, " vs ", _clanB)));
    }

    function endWar(uint256 _id) external onlyOwner {
        require(_id < wars.length, "invalid war");
        wars[_id].active = false;
        emit WarEnded(_id);
        eventBoard.postEvent("Clan War Ended", string(abi.encodePacked("War #", uintToString(_id), " ended")));
    }

    function createTournament(string memory _name, string[] memory _participants) external onlyOwner {
        tournaments.push(Tournament(tournaments.length, _name, _participants, 1, false));
        emit TournamentCreated(tournaments.length - 1, _name);
        eventBoard.postEvent("Tournament Created", string(abi.encodePacked(_name, " started")));
    }

    function advanceTournament(uint256 _id) external onlyOwner {
        require(_id < tournaments.length, "invalid tournament");
        tournaments[_id].round++;
        emit TournamentAdvanced(_id, tournaments[_id].round);
    }

    function finishTournament(uint256 _id, string memory _winner) external onlyOwner {
        require(_id < tournaments.length, "invalid tournament");
        tournaments[_id].finished = true;
        emit TournamentFinished(_id, _winner);
        eventBoard.postEvent("Tournament Finished", string(abi.encodePacked("Winner: ", _winner)));
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
