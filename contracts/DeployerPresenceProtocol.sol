pragma solidity ^0.8.20;

contract DeployerPresenceProtocol {
    address public deployer;

    struct Deployment {
        string project;      // e.g. infrastructure, energy, transport
        string status;       // e.g. deployed, pending, failed
        uint256 timestamp;
    }

    Deployment[] public deployments;

    event DeploymentLogged(string project, string status, uint256 timestamp);

    constructor() { deployer = msg.sender; }

    modifier onlyDeployer() { require(msg.sender == deployer, "Not deployer"); _; }

    function logDeployment(string calldata project, string calldata status) external onlyDeployer {
        deployments.push(Deployment(project, status, block.timestamp));
        emit DeploymentLogged(project, status, block.timestamp);
    }

    function totalDeployments() external view returns (uint256) {
        return deployments.length;
    }
}
