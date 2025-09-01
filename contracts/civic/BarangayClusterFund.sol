// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangayClusterFund {
    struct Cluster {
        string clusterID;
        string[] barangays;
        uint256 pooledAmount;
        string programFocus; // "Housing", "Energy", "Livelihood"
        string emotionalTag; // "DamayClause", "RemoteGlow", "AuditGlow"
        bool isBlessed;
        uint256 timestamp;
    }

    Cluster[] public clusters;

    function createCluster(string memory clusterID, string[] memory barangays, uint256 pooledAmount, string memory programFocus, string memory emotionalTag, bool isBlessed) public {
        clusters.push(Cluster(clusterID, barangays, pooledAmount, programFocus, emotionalTag, isBlessed, block.timestamp));
    }

    function totalClusters() public view returns (uint256) {
        return clusters.length;
    }
}
