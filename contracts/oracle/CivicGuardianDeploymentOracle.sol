// SPDX-License-Identifier: CivicGuardianDeployment-License
pragma solidity ^0.8.0;

contract CivicGuardianDeploymentOracle {
    address public steward;

    struct DeploymentPulse {
        string city;
        string zone;
        string deploymentType;
        bool emergencyDeclared;
        uint256 timestamp;
    }

    DeploymentPulse[] public pulses;

    event DeploymentPulseEmitted(string city, string zone, string deploymentType, bool emergency, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory city, string memory zone, string memory deploymentType, bool emergencyDeclared) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(DeploymentPulse(city, zone, deploymentType, emergencyDeclared, block.timestamp));
        emit DeploymentPulseEmitted(city, zone, deploymentType, emergencyDeclared, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        DeploymentPulse memory p = pulses[index];
        return (p.city, p.zone, p.deploymentType, p.emergencyDeclared, p.timestamp);
    }
}
