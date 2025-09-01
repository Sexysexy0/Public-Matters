// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract MultiStakeholderApproval {
    struct Stakeholder {
        string name;
        string role;
        bool hasSigned;
        uint256 timestamp;
    }

    struct Project {
        string name;
        string location;
        uint256 budget;
        bool isApproved;
        mapping(string => Stakeholder) signatures;
        string[] requiredRoles;
    }

    mapping(bytes32 => Project) public projects;

    event StakeholderSigned(
        bytes32 indexed projectId,
        string stakeholderName,
        string role,
        uint256 timestamp
    );

    event ProjectApproved(
        bytes32 indexed projectId,
        string name,
        string location,
        uint256 budget,
        uint256 timestamp
    );

    function initializeProject(
        string memory name,
        string memory location,
        uint256 budget,
        string[] memory requiredRoles
    ) public {
        bytes32 projectId = keccak256(abi.encodePacked(name, location));
        Project storage p = projects[projectId];
        p.name = name;
        p.location = location;
        p.budget = budget;
        p.requiredRoles = requiredRoles;
        p.isApproved = false;
    }

    function signProject(
        bytes32 projectId,
        string memory stakeholderName,
        string memory role
    ) public {
        Project storage p = projects[projectId];
        p.signatures[role] = Stakeholder(stakeholderName, role, true, block.timestamp);
        emit StakeholderSigned(projectId, stakeholderName, role, block.timestamp);

        bool allSigned = true;
        for (uint i = 0; i < p.requiredRoles.length; i++) {
            if (!p.signatures[p.requiredRoles[i]].hasSigned) {
                allSigned = false;
                break;
            }
        }

        if (allSigned) {
            p.isApproved = true;
            emit ProjectApproved(projectId, p.name, p.location, p.budget, block.timestamp);
        }
    }

    function getProjectStatus(bytes32 projectId) public view returns (bool) {
        return projects[projectId].isApproved;
    }
}
