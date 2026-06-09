// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PCGamingShowcaseSafeguard
/// @notice Covenant contract to safeguard nostalgia aesthetics, narrative preference, and trailer fidelity
contract PCGamingShowcaseSafeguard {
    address public owner;

    struct ShowcaseEntry {
        string title;        // e.g. "Exodus", "Carcass Clad", "Serious Sam Shatterverse"
        string safeguard;    // reflection safeguard (nostalgia, narrative, fidelity)
        uint256 priority;    // systemic emphasis level
        uint256 timestamp;
    }

    ShowcaseEntry[] public showcases;

    event ShowcaseLogged(string title, string safeguard, uint256 priority, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new showcase safeguard
    function logShowcase(string memory title, string memory safeguard, uint256 priority) public onlyOwner {
        ShowcaseEntry memory newEntry = ShowcaseEntry(title, safeguard, priority, block.timestamp);
        showcases.push(newEntry);
        emit ShowcaseLogged(title, safeguard, priority, block.timestamp);
    }

    function getShowcase(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        ShowcaseEntry memory s = showcases[index];
        return (s.title, s.safeguard, s.priority, s.timestamp);
    }

    function getShowcaseCount() public view returns (uint256) {
        return showcases.length;
    }
}
