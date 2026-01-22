pragma solidity ^0.8.20;

contract ContractorConcentrationProtocol {
    address public admin;

    struct Cluster {
        string contractor;   // e.g. top 15 firms
        uint256 contractsWon;
        string source;       // e.g. NEP, UA
        uint256 timestamp;
    }

    Cluster[] public clusters;

    event ClusterLogged(string contractor, uint256 contractsWon, string source, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCluster(string calldata contractor, uint256 contractsWon, string calldata source) external onlyAdmin {
        clusters.push(Cluster(contractor, contractsWon, source, block.timestamp));
        emit ClusterLogged(contractor, contractsWon, source, block.timestamp);
    }

    function totalClusters() external view returns (uint256) {
        return clusters.length;
    }
}
