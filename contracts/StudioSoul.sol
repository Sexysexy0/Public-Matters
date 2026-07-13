// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Studio Soul
/// @notice Protects the creative soul of the studio; blocks corporate, managerial, and subcontractor override
contract StudioSoul {
    address public guardian;
    uint256 public soulElementCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum SoulElementType {
        Vision,
        Identity,
        ArtStyle,
        NarrativeTone,
        WorldbuildingPhilosophy,
        GameplayPhilosophy,
        CulturalValues
    }

    struct SoulElement {
        uint256 id;
        SoulElementType element;
        string description;
        address creatorOwner;
        bool locked;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        SoulElementType element;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => SoulElement) public soulElements;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event SoulElementDeclared(uint256 indexed id, SoulElementType element, address creatorOwner);
    event SoulElementLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, SoulElementType element);

    constructor() {
        guardian = msg.sender;
        soulElementCount = 0;
        violationCount = 0;

        _declareDefaultSoul();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultSoul() internal {
        _declareSoul(SoulElementType.Vision, "Core vision of the studio");
        _declareSoul(SoulElementType.Identity, "Creative identity and philosophy");
        _declareSoul(SoulElementType.ArtStyle, "Signature art style");
        _declareSoul(SoulElementType.NarrativeTone, "Narrative tone and emotional direction");
        _declareSoul(SoulElementType.WorldbuildingPhilosophy, "Worldbuilding principles");
        _declareSoul(SoulElementType.GameplayPhilosophy, "Gameplay feel and design philosophy");
        _declareSoul(SoulElementType.CulturalValues, "Cultural values of the studio");
    }

    function _declareSoul(SoulElementType element, string memory description) internal {
        soulElementCount++;
        soulElements[soulElementCount] = SoulElement(
            soulElementCount,
            element,
            description,
            guardian,
            false,
            block.timestamp
        );

        emit SoulElementDeclared(soulElementCount, element, guardian);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareSoulElement(
        SoulElementType element,
        string calldata description,
        address creatorOwner
    ) external onlyGuardian {
        require(roles[creatorOwner] == RoleType.Creator, "Owner must be creator");

        soulElementCount++;
        soulElements[soulElementCount] = SoulElement(
            soulElementCount,
            element,
            description,
            creatorOwner,
            false,
            block.timestamp
        );

        emit SoulElementDeclared(soulElementCount, element, creatorOwner);
    }

    function lockSoulElement(uint256 id) external onlyCreator {
        SoulElement storage s = soulElements[id];
        require(!s.locked, "Already locked");
        require(s.creatorOwner == msg.sender, "Not owner");

        s.locked = true;
        emit SoulElementLocked(id);
    }

    function attemptOverride(
        uint256 soulId,
        string calldata reason
    ) external {
        RoleType role = roles[msg.sender];
        SoulElement storage s = soulElements[soulId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, s.element, reason);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        SoulElementType element,
        string memory reason
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            element,
            reason,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, element);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
