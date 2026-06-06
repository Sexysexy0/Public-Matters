// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PortalFilmSafeguard
/// @notice Covenant contract to safeguard Portal film adaptation aesthetics, puzzle logic, and dark humor
contract PortalFilmSafeguard {
    address public owner;

    struct Safeguard {
        string domain;       // e.g. "Liminal Horror", "Puzzle Logic", "Dark Humor"
        string description;  // safeguard details
        uint256 weight;      // placeholder metric for emphasis balance
        uint256 timestamp;
    }

    Safeguard[] public safeguards;

    event SafeguardLogged(string domain, string description, uint256 weight, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new film safeguard
    function logSafeguard(string memory domain, string memory description, uint256 weight) public onlyOwner {
        Safeguard memory newSafeguard = Safeguard(domain, description, weight, block.timestamp);
        safeguards.push(newSafeguard);
        emit SafeguardLogged(domain, description, weight, block.timestamp);
    }

    function getSafeguard(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        Safeguard memory s = safeguards[index];
        return (s.domain, s.description, s.weight, s.timestamp);
    }

    function getSafeguardCount() public view returns (uint256) {
        return safeguards.length;
    }
}
