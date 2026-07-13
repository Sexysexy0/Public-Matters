// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Studio Ownership
/// @notice Ensures that creators, not managers or subcontractors, own the vision and direction of the project
contract StudioOwnership {
    address public guardian;
    uint256 public creatorCount;
    uint256 public visionCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Subcontractor
    }

    struct Member {
        uint256 id;
        address account;
        RoleType role;
        string specialty;
        bool active;
    }

    struct Vision {
        uint256 id;
        string title;
        string description;
        address ownerCreator;
        bool locked;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        string subject;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Member) public members;
    mapping(uint256 => Vision) public visions;
    mapping(uint256 => Violation) public violations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event MemberAdded(uint256 indexed id, address account, RoleType role, string specialty);
    event VisionDeclared(uint256 indexed id, string title, address ownerCreator);
    event VisionLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, string subject);

    constructor() {
        guardian = msg.sender;
        creatorCount = 0;
        visionCount = 0;
        violationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    // Add member (creator, manager, subcontractor)
    function addMember(
        address account,
        RoleType role,
        string calldata specialty
    ) external onlyGuardian {
        creatorCount++;
        members[creatorCount] = Member(creatorCount, account, role, specialty, true);
        emit MemberAdded(creatorCount, account, role, specialty);
    }

    // Declare a vision owned by a creator
    function declareVision(
        string calldata title,
        string calldata description,
        address ownerCreator
    ) external onlyGuardian {
        require(_isCreator(ownerCreator), "Owner must be a creator");

        visionCount++;
        visions[visionCount] = Vision(
            visionCount,
            title,
            description,
            ownerCreator,
            false,
            block.timestamp
        );

        emit VisionDeclared(visionCount, title, ownerCreator);
    }

    // Lock vision so managers/subcontractors cannot override
    function lockVision(uint256 id) external onlyGuardian {
        Vision storage v = visions[id];
        require(!v.locked, "Already locked");
        v.locked = true;
        emit VisionLocked(id);
    }

    // Attempt override = violation
    function attemptOverride(
        uint256 visionId,
        address violator,
        string calldata reason
    ) external onlyGuardian {
        RoleType role = _getRole(violator);

        if (role != RoleType.Creator) {
            _logViolation(violator, role, visions[visionId].title, reason);
        }
    }

    // Internal violation logger
    function _logViolation(
        address violator,
        RoleType role,
        string memory subject,
        string memory reason
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            subject,
            reason,
            block.timestamp
        );
        emit ViolationLogged(violationCount, violator, subject);
    }

    function _isCreator(address account) internal view returns (bool) {
        for (uint256 i = 1; i <= creatorCount; i++) {
            if (members[i].account == account && members[i].role == RoleType.Creator) {
                return true;
            }
        }
        return false;
    }

    function _getRole(address account) internal view returns (RoleType) {
        for (uint256 i = 1; i <= creatorCount; i++) {
            if (members[i].account == account) {
                return members[i].role;
            }
        }
        return RoleType.Subcontractor;
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
