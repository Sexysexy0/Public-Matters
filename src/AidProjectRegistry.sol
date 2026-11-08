// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

contract AidProjectRegistry {
    OperatorPrivileges public immutable privileges;
    
    struct Project {
        bytes32 id;
        bytes32 donorHash;
        bytes32 locationHash;
        bytes32 assetHash; // e.g., "Water Well #42"
        address localOperator;
        uint256 totalAid;
        bool active;
    }
    
    mapping(bytes32 => Project) public projects;
    
    event ProjectCreated(bytes32 indexed id, bytes32 indexed assetHash, address localOperator, uint256 totalAid);
    event ProjectClosed(bytes32 indexed id);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function createProject(
        bytes32 projectId,
        bytes32 donorHash,
        bytes32 locationHash,
        bytes32 assetHash,
        address localOperator,
        uint256 totalAid
    ) external onlyOperator {
        require(projects[projectId].id == bytes32(0), "Project exists");
        projects[projectId] = Project({
            id: projectId,
            donorHash: donorHash,
            locationHash: locationHash,
            assetHash: assetHash,
            localOperator: localOperator,
            totalAid: totalAid,
            active: true
        });
        emit ProjectCreated(projectId, assetHash, localOperator, totalAid);
    }

    function closeProject(bytes32 projectId) external onlyOperator {
        require(projects[projectId].active, "Project not active");
        projects[projectId].active = false;
        emit ProjectClosed(projectId);
    }

    function getProject(bytes32 projectId) external view returns (Project memory) {
        return projects[projectId];
    }
}
