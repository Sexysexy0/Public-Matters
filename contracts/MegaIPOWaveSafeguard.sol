// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MegaIPOWaveSafeguard
/// @notice Covenant contract to safeguard systemic resilience during simultaneous frontier tech IPOs
contract MegaIPOWaveSafeguard {
    address public owner;

    struct Safeguard {
        string domain;       // e.g. "Liquidity", "Valuation Discipline", "Investor Protection"
        string description;  // safeguard details
        uint256 priority;    // placeholder metric for systemic emphasis
        uint256 timestamp;
    }

    Safeguard[] public safeguards;

    event SafeguardLogged(string domain, string description, uint256 priority, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new IPO safeguard
    function logSafeguard(string memory domain, string memory description, uint256 priority) public onlyOwner {
        Safeguard memory newSafeguard = Safeguard(domain, description, priority, block.timestamp);
        safeguards.push(newSafeguard);
        emit SafeguardLogged(domain, description, priority, block.timestamp);
    }

    function getSafeguard(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        Safeguard memory s = safeguards[index];
        return (s.domain, s.description, s.priority, s.timestamp);
    }

    function getSafeguardCount() public view returns (uint256) {
        return safeguards.length;
    }
}
