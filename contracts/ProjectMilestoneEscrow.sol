// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Simplified interface for the MultiSig Vault (Nilipat natin sa labas para safe!)
interface IMultiSigVault {
    function submitTransaction(address payable _to, uint256 _value, bytes calldata _data) external returns (uint256);
}

/**
 * @title ProjectMilestoneEscrow
 * @dev Bridges Treaty IDs to the MultiSig Vault for automated milestone funding
 */
contract ProjectMilestoneEscrow {
    address public immutable owner;
    
    // Reference to the MultiSig Vault (Brick 2)
    IMultiSigVault public vault;
    
    struct Milestone {
        string description;
        uint256 amount;
        bool isCompleted;
        uint256 completedAt;
    }

    struct Project {
        uint256 treatyId;         // Reference to TokenizedTreatyBase ID
        address payable recipient; // Who gets paid upon completion
        uint256 totalFunds;
        uint256 fundsDisbursed;
        Milestone[] milestones;
        bool isActive;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectCreated(uint256 indexed id, uint256 treatyId, address recipient);
    event MilestoneCompleted(uint256 indexed projectId, uint256 milestoneIndex, uint256 amountReleased);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier projectExists(uint256 _id) {
        require(projects[_id].treatyId > 0, "Project does not exist");
        _;
    }

    constructor(address _vaultAddress) {
        owner = msg.sender;
        vault = IMultiSigVault(_vaultAddress);
    }

    function createProject(
        uint256 _treatyId,
        address payable _recipient,
        string[] memory _milestoneDescriptions,
        uint256[] memory _milestoneAmounts
    ) external onlyOwner returns (uint256) {
        require(_recipient != address(0), "Invalid recipient");
        require(_milestoneDescriptions.length == _milestoneAmounts.length, "Mismatched arrays");
        require(_milestoneDescriptions.length > 0, "Need at least 1 milestone");

        projectCount++;
        Project storage project = projects[projectCount];
        project.treatyId = _treatyId;
        project.recipient = _recipient;
        project.isActive = true;

        uint256 total = 0;
        for (uint256 i = 0; i < _milestoneAmounts.length; i++) {
            require(_milestoneAmounts[i] > 0, "Milestone amount must be > 0");
            project.milestones.push(Milestone({
                description: _milestoneDescriptions[i],
                amount: _milestoneAmounts[i],
                isCompleted: false,
                completedAt: 0
            }));
            total += _milestoneAmounts[i];
        }

        project.totalFunds = total;
        emit ProjectCreated(projectCount, _treatyId, _recipient);
        return projectCount;
    }

    function completeMilestone(uint256 _projectId, uint256 _milestoneIndex) external onlyOwner projectExists(_projectId) {
        Project storage project = projects[_projectId];
        require(_milestoneIndex < project.milestones.length, "Invalid milestone index");
        require(project.isActive, "Project is closed");

        Milestone storage milestone = project.milestones[_milestoneIndex];
        require(!milestone.isCompleted, "Milestone already done");

        milestone.isCompleted = true;
        milestone.completedAt = block.timestamp;
        project.fundsDisbursed += milestone.amount;

        // Automatically submit the funding request to the MultiSig Vault
        vault.submitTransaction(project.recipient, milestone.amount, "");

        emit MilestoneCompleted(_projectId, _milestoneIndex, milestone.amount);
    }

    function getProject(uint256 _id) external view returns (Project memory) {
        return projects[_id];
    }
}
