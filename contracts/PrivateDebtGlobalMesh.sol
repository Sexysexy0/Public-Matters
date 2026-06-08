// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PrivateDebtGlobalMesh
/// @notice Covenant contract to unify alliance outcomes into global mesh governance across continents
contract PrivateDebtGlobalMesh {
    address public owner;

    struct MeshAction {
        uint256 allianceDecisionId; // linked to PrivateDebtConvergenceAlliance entry
        string region;              // e.g. "US", "EU", "APAC"
        string domain;              // e.g. "Private Credit Growth", "CRE Valuations", "Debt Market Resilience"
        string globalDirective;     // mesh-level governance directive
        bool ratified;
        uint256 timestamp;
    }

    MeshAction[] public actions;

    event MeshRatified(uint256 allianceDecisionId, string region, string domain, string globalDirective, bool ratified, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Ratify alliance decision into global mesh governance
    function ratifyMesh(uint256 allianceDecisionId, string memory region, string memory domain, string memory globalDirective, bool ratified) public onlyOwner {
        MeshAction memory newAction = MeshAction(allianceDecisionId, region, domain, globalDirective, ratified, block.timestamp);
        actions.push(newAction);
        emit MeshRatified(allianceDecisionId, region, domain, globalDirective, ratified, block.timestamp);
    }

    function getMeshAction(uint256 index) public view returns (uint256, string memory, string memory, string memory, bool, uint256) {
        MeshAction memory m = actions[index];
        return (m.allianceDecisionId, m.region, m.domain, m.globalDirective, m.ratified, m.timestamp);
    }

    function getMeshCount() public view returns (uint256) {
        return actions.length;
    }
}
