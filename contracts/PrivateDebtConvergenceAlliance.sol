// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PrivateDebtConvergenceAlliance
/// @notice Covenant contract to unify council outcomes into alliance-level governance across institutions and markets
contract PrivateDebtConvergenceAlliance {
    address public owner;

    struct AllianceDecision {
        uint256 resolutionId;  // linked to PrivateDebtCouncil entry
        string domain;         // e.g. "Private Credit Growth", "CRE Valuations", "Debt Market Resilience"
        string allianceAction; // alliance-level governance action
        bool ratified;
        uint256 timestamp;
    }

    AllianceDecision[] public decisions;

    event AllianceRatified(uint256 resolutionId, string domain, string allianceAction, bool ratified, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Ratify council resolution into alliance governance
    function ratifyAlliance(uint256 resolutionId, string memory domain, string memory allianceAction, bool ratified) public onlyOwner {
        AllianceDecision memory newDecision = AllianceDecision(resolutionId, domain, allianceAction, ratified, block.timestamp);
        decisions.push(newDecision);
        emit AllianceRatified(resolutionId, domain, allianceAction, ratified, block.timestamp);
    }

    function getAllianceDecision(uint256 index) public view returns (uint256, string memory, string memory, bool, uint256) {
        AllianceDecision memory a = decisions[index];
        return (a.resolutionId, a.domain, a.allianceAction, a.ratified, a.timestamp);
    }

    function getAllianceCount() public view returns (uint256) {
        return decisions.length;
    }
}
