// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MilitaryJuntaSafeguards
/// @notice Covenant contract to encode protections against authoritarian military rule
contract MilitaryJuntaSafeguards {
    address public owner;

    struct Safeguard {
        string risk;        // e.g. "Military Junta", "Authoritarian Coup"
        string action;      // covenant safeguard action
        uint256 timestamp;
    }

    Safeguard[] public safeguards;

    event SafeguardLogged(string risk, string action, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logSafeguard(string memory risk, string memory action) public onlyOwner {
        Safeguard memory newSafeguard = Safeguard(risk, action, block.timestamp);
        safeguards.push(newSafeguard);
        emit SafeguardLogged(risk, action, block.timestamp);
    }

    function getSafeguard(uint256 index) public view returns (string memory, string memory, uint256) {
        Safeguard memory s = safeguards[index];
        return (s.risk, s.action, s.timestamp);
    }

    function getSafeguardCount() public view returns (uint256) {
        return safeguards.length;
    }
}
