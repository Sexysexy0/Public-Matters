// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PrivateDebtCouncil
/// @notice Covenant contract to govern private credit and debt market transparency outcomes at council level
contract PrivateDebtCouncil {
    address public owner;

    struct Resolution {
        uint256 outcomeId;    // linked to PrivateDebtTransparency entry
        string domain;        // e.g. "Private Credit Growth", "CRE Valuations", "Debt Market Resilience"
        string decision;      // council resolution details
        bool ratified;
        uint256 timestamp;
    }

    Resolution[] public resolutions;

    event ResolutionRatified(uint256 outcomeId, string domain, string decision, bool ratified, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Ratify a transparency outcome into council governance
    function ratifyResolution(uint256 outcomeId, string memory domain, string memory decision, bool ratified) public onlyOwner {
        Resolution memory newResolution = Resolution(outcomeId, domain, decision, ratified, block.timestamp);
        resolutions.push(newResolution);
        emit ResolutionRatified(outcomeId, domain, decision, ratified, block.timestamp);
    }

    function getResolution(uint256 index) public view returns (uint256, string memory, string memory, bool, uint256) {
        Resolution memory r = resolutions[index];
        return (r.outcomeId, r.domain, r.decision, r.ratified, r.timestamp);
    }

    function getResolutionCount() public view returns (uint256) {
        return resolutions.length;
    }
}
