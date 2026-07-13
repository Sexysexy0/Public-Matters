// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator First
/// @notice Enforces creator-first hierarchy; creators outrank managers in decision authority
contract CreatorFirst {
    address public guardian;
    uint256 public creatorCount;
    uint256 public managerCount;
    uint256 public decisionCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager
    }

    struct Member {
        uint256 id;
        address account;
        RoleType role;
        string specialty;
        bool active;
    }

    struct Decision {
        uint256 id;
        string subject;
        address creator;
        address manager;
        bool managerAttemptedOverride;
        bool creatorFinalAuthority;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address manager;
        string subject;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Member) public creators;
    mapping(uint256 => Member) public managers;
    mapping(uint256 => Decision) public decisions;
    mapping(uint256 => Violation) public violations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CreatorAdded(uint256 indexed id, address account, string specialty);
    event ManagerAdded(uint256 indexed id, address account, string specialty);
    event DecisionRecorded(uint256 indexed id, string subject, bool managerAttemptedOverride);
    event ViolationLogged(uint256 indexed id, address manager, string subject);

    constructor() {
        guardian = msg.sender;
        creatorCount = 0;
        managerCount = 0;
        decisionCount = 0;
        violationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    // Add creator
    function addCreator(address account, string calldata specialty) external onlyGuardian {
        creatorCount++;
        creators[creatorCount] = Member(creatorCount, account, RoleType.Creator, specialty, true);
        emit CreatorAdded(creatorCount, account, specialty);
    }

    // Add manager
    function addManager(address account, string calldata specialty) external onlyGuardian {
        managerCount++;
        managers[managerCount] = Member(managerCount, account, RoleType.Manager, specialty, true);
        emit ManagerAdded(managerCount, account, specialty);
    }

    // Record decision attempt
    function recordDecision(
        string calldata subject,
        address creator,
        address manager,
        bool managerAttemptedOverride
    ) external onlyGuardian {
        decisionCount++;
        decisions[decisionCount] = Decision(
            decisionCount,
            subject,
            creator,
            manager,
            managerAttemptedOverride,
            true,
            block.timestamp
        );

        emit DecisionRecorded(decisionCount, subject, managerAttemptedOverride);

        if (managerAttemptedOverride) {
            _logViolation(manager, subject, "Manager attempted to override creator authority");
        }
    }

    // Internal violation logger
    function _logViolation(address manager, string memory subject, string memory reason) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            manager,
            subject,
            reason,
            block.timestamp
        );
        emit ViolationLogged(violationCount, manager, subject);
    }

    // Manual violation logging
    function logViolation(address manager, string calldata subject, string calldata reason) external onlyGuardian {
        _logViolation(manager, subject, reason);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
