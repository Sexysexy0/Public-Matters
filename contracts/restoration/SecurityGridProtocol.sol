// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract SecurityGridProtocol {
    struct Deployment {
        string unitName;
        string location;
        string mission;
        string emotionalAPR;
        uint256 timestamp;
        address steward;
    }

    Deployment[] public deployments;

    event ForceDeployed(string unitName, string location, string mission, string emotionalAPR, address indexed steward);

    function logDeployment(
        string memory unitName,
        string memory location,
        string memory mission,
        string memory emotionalAPR
    ) public {
        deployments.push(Deployment(unitName, location, mission, emotionalAPR, block.timestamp, msg.sender));
        emit ForceDeployed(unitName, location, mission, emotionalAPR, msg.sender);
    }

    function getAllDeployments() public view returns (Deployment[] memory) {
        return deployments;
    }
}
