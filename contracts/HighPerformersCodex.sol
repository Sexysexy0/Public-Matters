// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HighPerformersCodex
/// @notice Covenant contract encoding safeguards for high-performing employee characteristics
contract HighPerformersCodex {
    address public owner;

    struct Safeguard {
        uint256 arcId;     // linked to employee performance arc
        string domain;     // e.g. "Basic Skills", "Judgment", "Self-Esteem", "Commitment", "Initiative", "Open-Mindedness", "Work Spirit"
        string decree;     // safeguard decree text
        uint256 timestamp;
    }

    Safeguard[] public safeguards;

    event Decreed(uint256 arcId, string domain, string decree, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Encode employee performance arc into covenant safeguard
    function decreeCodex(uint256 arcId, string memory domain, string memory decree) public onlyOwner {
        Safeguard memory newSafeguard = Safeguard(arcId, domain, decree, block.timestamp);
        safeguards.push(newSafeguard);
        emit Decreed(arcId, domain, decree, block.timestamp);
    }

    function getSafeguard(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        Safeguard memory s = safeguards[index];
        return (s.arcId, s.domain, s.decree, s.timestamp);
    }

    function getSafeguardCount() public view returns (uint256) {
        return safeguards.length;
    }
}
