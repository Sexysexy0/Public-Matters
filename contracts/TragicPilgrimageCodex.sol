// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TragicPilgrimageCodex
/// @notice Covenant contract to safeguard goodness vigilance, shadow confrontation, and labyrinth pilgrimage
contract TragicPilgrimageCodex {
    address public owner;

    struct Pilgrimage {
        string domain;        // e.g. "Goodness Vigilance", "Shadow Confrontation", "Labyrinth Journey"
        string reflection;    // mythic safeguard reflection
        uint256 depth;        // systemic emphasis level
        uint256 timestamp;
    }

    Pilgrimage[] public pilgrimages;

    event PilgrimageLogged(string domain, string reflection, uint256 depth, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new pilgrimage safeguard
    function logPilgrimage(string memory domain, string memory reflection, uint256 depth) public onlyOwner {
        Pilgrimage memory newPilgrimage = Pilgrimage(domain, reflection, depth, block.timestamp);
        pilgrimages.push(newPilgrimage);
        emit PilgrimageLogged(domain, reflection, depth, block.timestamp);
    }

    function getPilgrimage(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        Pilgrimage memory p = pilgrimages[index];
        return (p.domain, p.reflection, p.depth, p.timestamp);
    }

    function getPilgrimageCount() public view returns (uint256) {
        return pilgrimages.length;
    }
}
