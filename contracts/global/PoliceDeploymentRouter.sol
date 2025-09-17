// SPDX-License-Identifier: CivicSanctum
pragma solidity ^0.8.19;

contract PoliceDeploymentRouter {
    address public steward;

    struct Deployment {
        string city;
        uint256 policeUnits;
        bool nationalGuardWithdrawn;
        string reason; // e.g. "Stable Governance", "Low Crime", "Local Autonomy"
        uint256 timestamp;
    }

    Deployment[] public deployments;

    event DeploymentLogged(string city, uint256 policeUnits, bool nationalGuardWithdrawn, string reason, uint256 timestamp);
    event AutonomyVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logDeployment(
        string memory city,
        uint256 policeUnits,
        bool nationalGuardWithdrawn,
        string memory reason
    ) public {
        deployments.push(Deployment(city, policeUnits, nationalGuardWithdrawn, reason, block.timestamp));
        emit DeploymentLogged(city, policeUnits, nationalGuardWithdrawn, reason, block.timestamp);
    }

    function verifyAutonomy(uint256 index) public {
        require(index < deployments.length, "Invalid index");
        deployments[index].nationalGuardWithdrawn = true;
        emit AutonomyVerified(index, msg.sender);
    }

    function getDeployment(uint256 index) public view returns (
        string memory, uint256, bool, string memory, uint256
    ) {
        Deployment memory d = deployments[index];
        return (d.city, d.policeUnits, d.nationalGuardWithdrawn, d.reason, d.timestamp);
    }

    function totalDeployments() public view returns (uint256) {
        return deployments.length;
    }
}
