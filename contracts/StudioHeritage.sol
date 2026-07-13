// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Studio Heritage
/// @notice Protects multi-generation creative heritage; prevents corporate erasure, dilution, or distortion of lineage
contract StudioHeritage {
    address public guardian;
    uint256 public heritageCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum HeritageType {
        FoundationalPrinciple,
        ArtisticLineage,
        NarrativeLineage,
        WorldbuildingLineage,
        GameplayLineage,
        CulturalLineage,
        StudioTradition,
        GenerationalTransfer
    }

    struct HeritageEntry {
        uint256 id;
        HeritageType heritageType;
        string description;
        address creatorOwner;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        HeritageType heritageType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => HeritageEntry) public heritage;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event HeritageDeclared(uint256 indexed id, HeritageType heritageType, address creatorOwner);
    event HeritageLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, HeritageType heritageType);

    constructor() {
        guardian = msg.sender;
        heritageCount = 0;
        violationCount = 0;

        _declareDefaultHeritage();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultHeritage() internal {
        _declareHeritage(HeritageType.FoundationalPrinciple, "Core principles of the studio", guardian);
        _declareHeritage(HeritageType.ArtisticLineage, "Artistic lineage passed across generations", guardian);
        _declareHeritage(HeritageType.NarrativeLineage, "Narrative lineage and tone", guardian);
        _declareHeritage(HeritageType.WorldbuildingLineage, "Worldbuilding lineage and philosophy", guardian);
        _declareHeritage(HeritageType.GameplayLineage, "Gameplay lineage and feel", guardian);
        _declareHeritage(HeritageType.CulturalLineage, "Cultural lineage of the studio", guardian);
        _declareHeritage(HeritageType.StudioTradition, "Studio traditions preserved across eras", guardian);
        _declareHeritage(HeritageType.GenerationalTransfer, "Rules for passing heritage to next generation", guardian);
    }

    function _declareHeritage(
        HeritageType heritageType,
        string memory description,
        address creatorOwner
    ) internal {
        heritageCount++;
        heritage[heritageCount] = HeritageEntry(
            heritageCount,
            heritageType,
            description,
            creatorOwner,
            false,
            block.timestamp
        );

        emit HeritageDeclared(heritageCount, heritageType, creatorOwner);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareHeritage(
        HeritageType heritageType,
        string calldata description,
        address creatorOwner
    ) external onlyGuardian {
        require(roles[creatorOwner] == RoleType.Creator, "Owner must be creator");
        _declareHeritage(heritageType, description, creatorOwner);
    }

    function lockHeritage(uint256 id) external onlyCreator {
        HeritageEntry storage h = heritage[id];
        require(!h.immutableEntry, "Already immutable");
        require(h.creatorOwner == msg.sender, "Not owner");

        h.immutableEntry = true;
        emit HeritageLocked(id);
    }

    function attemptErase(
        uint256 heritageId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        HeritageEntry storage h = heritage[heritageId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, h.heritageType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        HeritageType heritageType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            heritageType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, heritageType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
