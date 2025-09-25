// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title AITrainingModule
/// @notice Registry for AI training modules, completion tracking, and civic broadcast
/// @dev Anchors validator-grade learning and emotional consequence tagging

contract AITrainingModule {
    address public steward;
    mapping(address => bool) public instructors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyInstructor() {
        require(instructors[msg.sender] || msg.sender == steward, "Not instructor");
        _;
    }

    struct Module {
        uint256 id;
        string title;
        string domain;
        string emotionalTag;
        bool active;
        uint256 createdAt;
    }

    struct Completion {
        uint256 moduleId;
        address trainee;
        string notes;
        uint256 completedAt;
    }

    uint256 public nextModuleId = 1;
    mapping(uint256 => Module) public modules;
    mapping(address => Completion[]) public completions;

    event InstructorSet(address indexed account, bool status);
    event ModuleCreated(uint256 indexed id, string title, string domain);
    event ModuleCompleted(uint256 indexed moduleId, address indexed trainee, string emotionalTag);

    constructor() {
        steward = msg.sender;
        instructors[msg.sender] = true;
        emit InstructorSet(msg.sender, true);
    }

    function setInstructor(address account, bool status) external onlySteward {
        instructors[account] = status;
        emit InstructorSet(account, status);
    }

    function createModule(string calldata title, string calldata domain, string calldata emotionalTag) external onlyInstructor returns (uint256 id) {
        id = nextModuleId++;
        modules[id] = Module({
            id: id,
            title: title,
            domain: domain,
            emotionalTag: emotionalTag,
            active: true,
            createdAt: block.timestamp
        });
        emit ModuleCreated(id, title, domain);
    }

    function completeModule(uint256 moduleId, address trainee, string calldata notes) external onlyInstructor {
        require(modules[moduleId].active, "Module inactive");
        completions[trainee].push(Completion({
            moduleId: moduleId,
            trainee: trainee,
            notes: notes,
            completedAt: block.timestamp
        }));
        emit ModuleCompleted(moduleId, trainee, modules[moduleId].emotionalTag);
    }

    function getModule(uint256 id) external view returns (Module memory) {
        return modules[id];
    }

    function listCompletions(address trainee) external view returns (Completion[] memory) {
        return completions[trainee];
    }
}
