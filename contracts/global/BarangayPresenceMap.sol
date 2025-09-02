// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangayPresenceMap {
    struct PulisPresence {
        string barangay;
        uint256 timestamp;
        uint8 visibilityScore; // 1–10 scale
        uint8 empathyScore;    // Emotional APR metric
        bool emotionallyTagged;
    }

    PulisPresence[] public deployments;

    event DeploymentLogged(string barangay, uint256 timestamp, uint8 visibilityScore, uint8 empathyScore);

    function logDeployment(
        string memory _barangay,
        uint8 _visibilityScore,
        uint8 _empathyScore,
        bool _emotionallyTagged
    ) public {
        deployments.push(PulisPresence(_barangay, block.timestamp, _visibilityScore, _empathyScore, _emotionallyTagged));
        emit DeploymentLogged(_barangay, block.timestamp, _visibilityScore, _empathyScore);
    }

    function getDeployment(uint256 index) public view returns (PulisPresence memory) {
        require(index < deployments.length, "Invalid index");
        return deployments[index];
    }

    function totalDeployments() public view returns (uint256) {
        return deployments.length;
    }
}
