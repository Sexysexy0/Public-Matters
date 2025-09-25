// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title SkillSanctumSimulator
/// @notice Simulates skill training sessions and tracks mastery with emotional consequence tagging
/// @dev Anchors civic broadcast and validator-grade learning rituals

contract SkillSanctumSimulator {
    address public steward;
    mapping(address => bool) public mentors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyMentor() {
        require(mentors[msg.sender] || msg.sender == steward, "Not mentor");
        _;
    }

    enum SkillStatus {
        Untrained,
        InProgress,
        Mastered,
        Broadcasted
    }

    struct SkillSession {
        uint256 id;
        address trainee;
        string skill;
        string module;
        SkillStatus status;
        string emotionalTag;
        uint256 startedAt;
        uint256 updatedAt;
    }

    uint256 public nextSessionId = 1;
    mapping(uint256 => SkillSession) public sessions;
    mapping(address => uint256[]) public traineeSessions;

    event MentorSet(address indexed account, bool status);
    event SkillSessionStarted(uint256 indexed id, address indexed trainee, string skill);
    event SkillStatusUpdated(uint256 indexed id, SkillStatus status, string emotionalTag);

    constructor() {
        steward = msg.sender;
        mentors[msg.sender] = true;
        emit MentorSet(msg.sender, true);
    }

    function setMentor(address account, bool status) external onlySteward {
        mentors[account] = status;
        emit MentorSet(account, status);
    }

    function startSession(address trainee, string calldata skill, string calldata module) external onlyMentor returns (uint256 id) {
        id = nextSessionId++;
        sessions[id] = SkillSession({
            id: id,
            trainee: trainee,
            skill: skill,
            module: module,
            status: SkillStatus.InProgress,
            emotionalTag: "",
            startedAt: block.timestamp,
            updatedAt: block.timestamp
        });
        traineeSessions[trainee].push(id);
        emit SkillSessionStarted(id, trainee, skill);
    }

    function updateStatus(uint256 id, SkillStatus status, string calldata emotionalTag) external onlyMentor {
        SkillSession storage s = sessions[id];
        require(s.id != 0, "Session not found");
        s.status = status;
        s.emotionalTag = emotionalTag;
        s.updatedAt = block.timestamp;
        emit SkillStatusUpdated(id, status, emotionalTag);
    }

    function getSession(uint256 id) external view returns (SkillSession memory) {
        return sessions[id];
    }

    function listTraineeSessions(address trainee) external view returns (uint256[] memory) {
        return traineeSessions[trainee];
    }
}
