// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MapRegistry {
    struct Map {
        string name;
        bool active;
    }

    Map[] public maps;
    mapping(uint256 => uint256) public votes; // mapId => voteCount
    mapping(address => bool) public hasVoted;

    event MapAdded(uint256 mapId, string name);
    event MapActivated(uint256 mapId);
    event Voted(address voter, uint256 mapId);

    function addMap(string memory _name) external {
        maps.push(Map(_name, false));
        emit MapAdded(maps.length - 1, _name);
    }

    function activateMap(uint256 _mapId) external {
        require(_mapId < maps.length, "Invalid map");
        maps[_mapId].active = true;
        emit MapActivated(_mapId);
    }

    function voteMap(uint256 _mapId) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(_mapId < maps.length, "Invalid map");
        votes[_mapId]++;
        hasVoted[msg.sender] = true;
        emit Voted(msg.sender, _mapId);
    }

    function getWinningMap() external view returns (string memory) {
        uint256 highestVotes;
        uint256 winningMapId;
        for (uint256 i = 0; i < maps.length; i++) {
            if (votes[i] > highestVotes) {
                highestVotes = votes[i];
                winningMapId = i;
            }
        }
        return maps[winningMapId].name;
    }
}
