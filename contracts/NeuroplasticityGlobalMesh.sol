// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NeuroplasticityGlobalMesh
/// @notice Covenant contract to unify alliance resolutions into global mesh governance
contract NeuroplasticityGlobalMesh {
    address public owner;

    struct MeshDirective {
        uint256 allianceResolutionId; // linked to NeuroplasticityAlliance entry
        string region;                // e.g. "US", "EU", "APAC"
        string domain;                // e.g. "Emotional Intelligence", "Leadership Empathy", "Team Synchronicity"
        string directive;             // global mesh governance directive
        bool ratified;
        uint256 timestamp;
    }

    MeshDirective[] public directives;

    event MeshRatified(uint256 allianceResolutionId, string region, string domain, string directive, bool ratified, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Ratify alliance resolution into global mesh governance
    function ratifyMesh(uint256 allianceResolutionId, string memory region, string memory domain, string memory directive, bool ratified) public onlyOwner {
        MeshDirective memory newDirective = MeshDirective(allianceResolutionId, region, domain, directive, ratified, block.timestamp);
        directives.push(newDirective);
        emit MeshRatified(allianceResolutionId, region, domain, directive, ratified, block.timestamp);
    }

    function getDirective(uint256 index) public view returns (uint256, string memory, string memory, string memory, bool, uint256) {
        MeshDirective memory d = directives[index];
        return (d.allianceResolutionId, d.region, d.domain, d.directive, d.ratified, d.timestamp);
    }

    function getDirectiveCount() public view returns (uint256) {
        return directives.length;
    }
}
