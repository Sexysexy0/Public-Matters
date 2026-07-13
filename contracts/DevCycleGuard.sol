// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Dev Cycle Guard
/// @notice Protects each development cycle from interference, shortcuts, sabotage, and external pressure
contract DevCycleGuard {
    address public guardian;
    uint256 public cycleCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum CycleStatus {
        Planned,
        Active,
        Completed,
        Interrupted
    }

    enum InterferenceType {
        ForcedDeadline,
        ScopeCut,
        ForcedRelease,
        ExecutiveOverride,
        PublisherPressure,
        ManagerSabotage,
        SubcontractorDisruption
    }

    struct Cycle {
        uint256 id;
        string name;
        string description;
        CycleStatus status;
        address ownerCreator;
        bool locked;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        InterferenceType interference;
        uint256 cycleId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Cycle) public cycles;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event CycleDeclared(uint256 indexed id, string name, address ownerCreator);
    event CycleStatusChanged(uint256 indexed id, CycleStatus status);
    event CycleLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, InterferenceType interference);

    constructor() {
        guardian = msg.sender;
        cycleCount = 0;
        violationCount = 0;

        _declareDefaultCycles();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultCycles() internal {
        _declareCycle("Prototype Cycle", "Initial prototyping and experimentation", guardian);
        _declareCycle("Core Systems Cycle", "Building core gameplay and engine systems", guardian);
        _declareCycle("Content Cycle", "Building worlds, quests, levels, narrative", guardian);
        _declareCycle("Polish Cycle", "Refinement, optimization, bug fixing", guardian);
        _declareCycle("Release Prep Cycle", "Final checks, QA, stability, certification", guardian);
    }

    function _declareCycle(
        string memory name,
        string memory description,
        address ownerCreator
    ) internal {
        cycleCount++;
        cycles[cycleCount] = Cycle(
            cycleCount,
            name,
            description,
            CycleStatus.Planned,
            ownerCreator,
            false,
            block.timestamp
        );

        emit CycleDeclared(cycleCount, name, ownerCreator);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareCycle(
        string calldata name,
        string calldata description,
        address ownerCreator
    ) external onlyGuardian {
        require(roles[ownerCreator] == RoleType.Creator, "Owner must be creator");
        _declareCycle(name, description, ownerCreator);
    }

    function updateCycleStatus(uint256 id, CycleStatus status) external onlyCreator {
        Cycle storage c = cycles[id];
        require(!c.locked, "Cycle locked");
        require(c.ownerCreator == msg.sender, "Not owner");

        c.status = status;
        emit CycleStatusChanged(id, status);
    }

    function lockCycle(uint256 id) external onlyCreator {
        Cycle storage c = cycles[id];
        require(!c.locked, "Already locked");
        require(c.ownerCreator == msg.sender, "Not owner");

        c.locked = true;
        emit CycleLocked(id);
    }

    function attemptInterference(
        uint256 cycleId,
        InterferenceType interference,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        Cycle storage c = cycles[cycleId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, interference, cycleId, details);
            c.status = CycleStatus.Interrupted;
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        InterferenceType interference,
        uint256 cycleId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            interference,
            cycleId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, interference);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
