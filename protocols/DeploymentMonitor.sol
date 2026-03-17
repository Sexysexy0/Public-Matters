// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeploymentMonitor {
    event ContractDeployed(address indexed deployer, string name, address contractAddress, uint timestamp);

    function logDeployment(string memory name, address contractAddress) public {
        emit ContractDeployed(msg.sender, name, contractAddress, block.timestamp);
    }
}
