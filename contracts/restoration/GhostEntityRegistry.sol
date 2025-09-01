// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GhostEntityRegistry {
    struct GhostEntity {
        string name;
        string suspectedAlias;
        string violationType; // e.g. "No SEC Reg", "Fake App", "Shell Firm"
        string emotionalTag;
        bool confirmed;
        uint256 timestamp;
    }

    GhostEntity[] public ghosts;

    event GhostLogged(string name, string suspectedAlias, string violationType, string emotionalTag, bool confirmed);

    function logGhost(
        string memory _name,
        string memory _suspectedAlias,
        string memory _violationType,
        string memory _emotionalTag,
        bool _confirmed
    ) public {
        ghosts.push(GhostEntity(_name, _suspectedAlias, _violationType, _emotionalTag, _confirmed, block.timestamp));
        emit GhostLogged(_name, _suspectedAlias, _violationType, _emotionalTag, _confirmed);
    }

    function getGhost(uint256 index) public view returns (GhostEntity memory) {
        return ghosts[index];
    }

    function totalGhosts() public view returns (uint256) {
        return ghosts.length;
    }
}
