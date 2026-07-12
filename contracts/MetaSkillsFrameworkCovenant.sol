// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsFrameworkCovenant
// Purpose: Encode SDS meta-skills clusters (Self-management, Social intelligence, Innovation)
// Source: SDS Progression Framework (Integrity, Communicating, Curiosity, Creativity, etc.)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsFrameworkCovenant {
    address public chiefOperator;

    struct Cluster {
        string name;        // e.g. Self-management, Social intelligence, Innovation
        string[] skills;    // e.g. Integrity, Communicating, Adapting, Creativity
        uint256 timestamp;
    }

    Cluster[] public clusters;

    event ClusterLogged(string name, string[] skills, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logCluster(string memory name, string[] memory skills) public onlyChief {
        clusters.push(Cluster(name, skills, block.timestamp));
        emit ClusterLogged(name, skills, block.timestamp);
    }

    function getCluster(uint256 index) public view returns (
        string memory, string[] memory, uint256
    ) {
        require(index < clusters.length, "Invalid cluster index");
        Cluster memory c = clusters[index];
        return (c.name, c.skills, c.timestamp);
    }
}
