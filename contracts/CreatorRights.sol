// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Rights
/// @notice Bill of Rights for creators; protects creative authority, labor, and vision from corporate override
contract CreatorRights {
    address public guardian;
    uint256 public rightsCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum RightType {
        VisionOwnership,
        FinalSay,
        PipelineControl,
        AntiCrunch,
        AntiOverride,
        CreditIntegrity,
        CompensationIntegrity,
        CreativeFreedom
    }

    struct Right {
        uint256 id;
        RightType rightType;
        string description;
        bool locked;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        RightType rightType;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Right) public rights;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event RightDeclared(uint256 indexed id, RightType rightType);
    event RightLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, RightType rightType);

    constructor() {
        guardian = msg.sender;
        rightsCount = 0;
        violationCount = 0;

        _declareDefaultRights();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultRights() internal {
        _declareRight(RightType.VisionOwnership, "Creators own the vision.");
        _declareRight(RightType.FinalSay, "Creators have final say over creative decisions.");
        _declareRight(RightType.PipelineControl, "Creators control the development pipeline.");
        _declareRight(RightType.AntiCrunch, "Creators cannot be forced into crunch.");
        _declareRight(RightType.AntiOverride, "Managers, executives, publishers cannot override creators.");
        _declareRight(RightType.CreditIntegrity, "Creators must receive accurate and full credit.");
        _declareRight(RightType.CompensationIntegrity, "Creators must receive fair compensation.");
        _declareRight(RightType.CreativeFreedom, "Creators have freedom from corporate censorship.");
    }

    function _declareRight(RightType rightType, string memory description) internal {
        rightsCount++;
        rights[rightsCount] = Right(
            rightsCount,
            rightType,
            description,
            false,
            block.timestamp
        );

        emit RightDeclared(rightsCount, rightType);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareRight(
        RightType rightType,
        string calldata description
    ) external onlyGuardian {
        _declareRight(rightType, description);
    }

    function lockRight(uint256 id) external onlyCreator {
        Right storage r = rights[id];
        require(!r.locked, "Already locked");

        r.locked = true;
        emit RightLocked(id);
    }

    function attemptViolation(
        uint256 rightId,
        string calldata reason
    ) external {
        RoleType role = roles[msg.sender];
        Right storage r = rights[rightId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, r.rightType, reason);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        RightType rightType,
        string memory reason
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            rightType,
            reason,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, rightType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
