// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChristianYouthRestoration
/// @notice Covenant contract to safeguard and restore young men through church mission
contract ChristianYouthRestoration {
    address public owner;

    struct Restoration {
        string domain;       // e.g. "Masculine Dignity", "Community Purpose", "Truth and Courage"
        string description;  // restoration safeguard details
        uint256 priority;    // systemic emphasis
        uint256 timestamp;
    }

    Restoration[] public restorations;

    event RestorationLogged(string domain, string description, uint256 priority, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new restoration safeguard
    function logRestoration(string memory domain, string memory description, uint256 priority) public onlyOwner {
        Restoration memory newRestoration = Restoration(domain, description, priority, block.timestamp);
        restorations.push(newRestoration);
        emit RestorationLogged(domain, description, priority, block.timestamp);
    }

    function getRestoration(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        Restoration memory r = restorations[index];
        return (r.domain, r.description, r.priority, r.timestamp);
    }

    function getRestorationCount() public view returns (uint256) {
        return restorations.length;
    }
}
