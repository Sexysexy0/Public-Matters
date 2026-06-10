// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InnovationCodex
/// @notice Covenant contract encoding agility, analytics, leadership divergence, and IT scaffolding
contract InnovationCodex {
    address public owner;

    struct Safeguard {
        uint256 reportId;   // linked to NetApp Innovation Report entry
        string domain;      // e.g. "Agility", "Analytics", "Leadership", "IT Scaffolding"
        string decree;      // safeguard decree text
        uint256 timestamp;
    }

    Safeguard[] public safeguards;

    event Decreed(uint256 reportId, string domain, string decree, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Encode innovation report into covenant safeguard
    function decreeInnovation(uint256 reportId, string memory domain, string memory decree) public onlyOwner {
        Safeguard memory newSafeguard = Safeguard(reportId, domain, decree, block.timestamp);
        safeguards.push(newSafeguard);
        emit Decreed(reportId, domain, decree, block.timestamp);
    }

    function getSafeguard(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        Safeguard memory s = safeguards[index];
        return (s.reportId, s.domain, s.decree, s.timestamp);
    }

    function getSafeguardCount() public view returns (uint256) {
        return safeguards.length;
    }
}
