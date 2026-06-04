// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InvestorResilience
/// @notice Covenant contract to unify transparency, ownership, and scaling safeguards for investors
contract InvestorResilience {
    address public owner;

    struct Safeguard {
        string domain;       // e.g. "Transparency", "Ownership", "Scaling"
        string description;  // safeguard details
        address linkedContract; // linked module contract
        uint256 timestamp;
    }

    Safeguard[] public safeguards;

    event SafeguardRegistered(string domain, string description, address linkedContract, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new investor safeguard
    function registerSafeguard(string memory domain, string memory description, address linkedContract) public onlyOwner {
        Safeguard memory newSafeguard = Safeguard(domain, description, linkedContract, block.timestamp);
        safeguards.push(newSafeguard);
        emit SafeguardRegistered(domain, description, linkedContract, block.timestamp);
    }

    function getSafeguard(uint256 index) public view returns (string memory, string memory, address, uint256) {
        Safeguard memory s = safeguards[index];
        return (s.domain, s.description, s.linkedContract, s.timestamp);
    }

    function getSafeguardCount() public view returns (uint256) {
        return safeguards.length;
    }
}
