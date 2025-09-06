// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LaborDignityIndex {
    address public steward;

    struct JobRole {
        string title;
        string sector;
        uint256 emotionalAPR; // Scale: 0–100
        uint256 civicImpact;  // Scale: 0–100
        bool dignityCertified;
        uint256 timestamp;
    }

    JobRole[] public roles;

    event RoleCertified(string title, string sector, uint256 emotionalAPR, uint256 civicImpact, uint256 timestamp);
    event RoleRevoked(string title, string sector, string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function certifyRole(string memory title, string memory sector, uint256 emotionalAPR, uint256 civicImpact) external onlySteward {
        bool dignityCertified = (emotionalAPR + civicImpact) >= 120;
        roles.push(JobRole(title, sector, emotionalAPR, civicImpact, dignityCertified, block.timestamp));

        if (dignityCertified) {
            emit RoleCertified(title, sector, emotionalAPR, civicImpact, block.timestamp);
        } else {
            emit RoleRevoked(title, sector, "Failed dignity threshold", block.timestamp);
        }
    }

    function getRole(uint256 index) external view returns (JobRole memory) {
        require(index < roles.length, "Index out of bounds");
        return roles[index];
    }

    function totalRoles() external view returns (uint256) {
        return roles.length;
    }
}
