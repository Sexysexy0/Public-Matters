// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Vision Archive
/// @notice Permanent archive of all creative decisions; prevents deletion, rewriting, or corporate erasure
contract VisionArchive {
    address public guardian;
    uint256 public entryCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum EntryType {
        VisionDecision,
        LoreDecision,
        ArtDecision,
        NarrativeDecision,
        GameplayDecision,
        WorldbuildingDecision,
        CulturalDecision,
        PipelineDecision
    }

    struct ArchiveEntry {
        uint256 id;
        EntryType entryType;
        string description;
        address creatorOwner;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        EntryType entryType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => ArchiveEntry) public archive;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event ArchiveEntryDeclared(uint256 indexed id, EntryType entryType, address creatorOwner);
    event ArchiveEntryLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, EntryType entryType);

    constructor() {
        guardian = msg.sender;
        entryCount = 0;
        violationCount = 0;

        _declareDefaultArchive();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultArchive() internal {
        _declareEntry(EntryType.VisionDecision, "Foundational vision decisions", guardian);
        _declareEntry(EntryType.LoreDecision, "Foundational lore decisions", guardian);
        _declareEntry(EntryType.ArtDecision, "Art direction decisions", guardian);
        _declareEntry(EntryType.NarrativeDecision, "Narrative direction decisions", guardian);
        _declareEntry(EntryType.GameplayDecision, "Gameplay direction decisions", guardian);
        _declareEntry(EntryType.WorldbuildingDecision, "Worldbuilding decisions", guardian);
        _declareEntry(EntryType.CulturalDecision, "Cultural identity decisions", guardian);
        _declareEntry(EntryType.PipelineDecision, "Pipeline direction decisions", guardian);
    }

    function _declareEntry(
        EntryType entryType,
        string memory description,
        address creatorOwner
    ) internal {
        entryCount++;
        archive[entryCount] = ArchiveEntry(
            entryCount,
            entryType,
            description,
            creatorOwner,
            false,
            block.timestamp
        );

        emit ArchiveEntryDeclared(entryCount, entryType, creatorOwner);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareEntry(
        EntryType entryType,
        string calldata description,
        address creatorOwner
    ) external onlyGuardian {
        require(roles[creatorOwner] == RoleType.Creator, "Owner must be creator");
        _declareEntry(entryType, description, creatorOwner);
    }

    function lockEntry(uint256 id) external onlyCreator {
        ArchiveEntry storage e = archive[id];
        require(!e.immutableEntry, "Already immutable");
        require(e.creatorOwner == msg.sender, "Not owner");

        e.immutableEntry = true;
        emit ArchiveEntryLocked(id);
    }

    function attemptErase(
        uint256 entryId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        ArchiveEntry storage e = archive[entryId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, e.entryType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        EntryType entryType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            entryType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, entryType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
