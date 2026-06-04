// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DemocracyResilience
/// @notice Covenant contract to safeguard democracy against corruption, dynasties, and military risks
contract DemocracyResilience {
    address public owner;

    struct Safeguard {
        string threat;       // e.g. "Trillion Heist", "Military Junta", "Political Dynasty"
        string action;       // covenant safeguard action
        uint256 timestamp;
    }

    Safeguard[] public safeguards;

    event SafeguardLogged(string threat, string action, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logSafeguard(string memory threat, string memory action) public onlyOwner {
        Safeguard memory newSafeguard = Safeguard(threat, action, block.timestamp);
        safeguards.push(newSafeguard);
        emit SafeguardLogged(threat, action, block.timestamp);
    }

    function getSafeguard(uint256 index) public view returns (string memory, string memory, uint256) {
        Safeguard memory s = safeguards[index];
        return (s.threat, s.action, s.timestamp);
    }

    function getSafeguardCount() public view returns (uint256) {
        return safeguards.length;
    }
}
