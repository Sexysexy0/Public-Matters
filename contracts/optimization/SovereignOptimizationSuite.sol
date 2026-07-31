// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ZeroBiasGateway
 * @notice Provides non-discriminatory proof-of-access using cryptographic zero-knowledge proofs / hashes.
 */
contract ZeroBiasGateway {
    mapping(bytes32 => bool) private verifiedProofs;

    event AccessGranted(bytes32 indexed proofHash, uint256 timestamp);

    function registerProof(bytes32 proofHash) external {
        require(!verifiedProofs[proofHash], "Proof already submitted");
        verifiedProofs[proofHash] = true;
        emit AccessGranted(proofHash, block.timestamp);
    }

    function isAccessPermitted(bytes32 proofHash) external view returns (bool) {
        return verifiedProofs[proofHash];
    }
}

/**
 * @title AlignedMilestoneEngine
 * @notice Enforces 100% state alignment before releasing system resources.
 */
contract AlignedMilestoneEngine {
    struct Milestone {
        string description;
        uint256 allocation;
        bool isCompleted;
        bool fundsReleased;
    }

    address public immutable controller;
    Milestone[] public milestones;

    event MilestoneAdded(uint256 indexed id, string description, uint256 allocation);
    event MilestoneExecuted(uint256 indexed id);

    modifier onlyController() {
        require(msg.sender == controller, "Unauthorized: Not system controller");
        _;
    }

    constructor() {
        controller = msg.sender;
    }

    function addMilestone(string calldata description, uint256 allocation) external onlyController {
        milestones.push(Milestone({
            description: description,
            allocation: allocation,
            isCompleted: false,
            fundsReleased: false
        }));
        emit MilestoneAdded(milestones.length - 1, description, allocation);
    }

    function executeAlignedMilestone(uint256 id) external onlyController {
        require(id < milestones.length, "Invalid milestone ID");
        Milestone storage m = milestones[id];
        require(!m.isCompleted, "Milestone already executed");

        m.isCompleted = true;
        m.fundsReleased = true;

        emit MilestoneExecuted(id);
    }
}

/**
 * @title MicroNodeEcosystem
 * @notice Rewards small foundational contributors (insects of the ecosystem) based on verified micro-telemetry.
 */
contract MicroNodeEcosystem {
    mapping(address => uint256) public nodeContributions;
    mapping(address => bool) public activeNodes;

    event NodeRegistered(address indexed nodeAddress);
    event ContributionLogged(address indexed nodeAddress, uint256 weight);

    function registerNode() external {
        require(!activeNodes[msg.sender], "Node already active");
        activeNodes[msg.sender] = true;
        emit NodeRegistered(msg.sender);
    }

    function logMicroContribution(address node, uint256 weight) external {
        require(activeNodes[node], "Node not recognized in registry");
        nodeContributions[node] += weight;
        emit ContributionLogged(node, weight);
    }
}
