// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Anti-Weaponization Covenant
/// @notice Encodes anti-weaponization safeguard.
/// @dev Complements PublicBenefitOracle, InnovationSafetyCovenant, and RiskContextReview.

contract AntiWeaponization {
    address public guardian;
    uint256 public covenantCount;
    uint256 public councilCount;

    // --- Role management (added for tests / governance) ---
    enum RoleType { None, Admin, Innovator, Auditor, Operator }

    mapping(address => RoleType) public roles;

    event RoleAssigned(address indexed who, RoleType role);
    event RoleRevoked(address indexed who);

    // --- Weaponization rules and status ---
    enum WeaponRule {
        WeaponizationIsProhibited,
        PeaceMandated,
        ExploitationSuppressed,
        TransparencyInWeaponizationSystems,
        PublicBenefitPriority
    }

    enum WeaponStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        WeaponizationBlocked
    }

    struct Rule {
        uint256 id;
        WeaponRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct WeaponCase {
        uint256 id;
        address proposer;
        string grounds;
        WeaponStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => WeaponCase) public weaponCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, WeaponRule ruleType);
    event RuleLocked(uint256 indexed id);
    event WeaponFiled(uint256 indexed id);
    event WeaponStatusChanged(uint256 indexed id, WeaponStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        covenantCount = 0;
        councilCount = 0;

        _declareDefaultRules();
        // bootstrap guardian role
        roles[guardian] = RoleType.Admin;
        emit RoleAssigned(guardian, RoleType.Admin);
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyCouncil() {
        require(councilMember[msg.sender], "Council only");
        _;
    }

    modifier onlyRole(RoleType _role) {
        require(roles[msg.sender] == _role, "Insufficient role");
        _;
    }

    // --- Role management functions ---
    /// @notice Assign a role to an address
    function assignRole(address who, RoleType role) external onlyGuardian {
        roles[who] = role;
        emit RoleAssigned(who, role);
    }

    /// @notice Revoke role (set to None)
    function revokeRole(address who) external onlyGuardian {
        roles[who] = RoleType.None;
        emit RoleRevoked(who);
    }

    /// @notice Helper to check role
    function hasRole(address who, RoleType role) public view returns (bool) {
        return roles[who] == role;
    }

    // --- Council management ---
    function addCouncilMember(address member) external onlyGuardian {
        require(!councilMember[member], "Already council");
        councilMember[member] = true;
        councilCount++;
        emit CouncilMemberAdded(member);
    }

    function removeCouncilMember(address member) external onlyGuardian {
        require(councilMember[member], "Not council");
        councilMember[member] = false;
        councilCount--;
        emit CouncilMemberRemoved(member);
    }

    // --- Rule declaration ---
    function _declareDefaultRules() internal {
        _declare(WeaponRule.WeaponizationIsProhibited, "Weaponization prohibited; denial required.");
        _declare(WeaponRule.PeaceMandated, "Peace mandated; violence blocked.");
        _declare(WeaponRule.ExploitationSuppressed, "Exploitation suppressed; fairness required.");
        _declare(WeaponRule.TransparencyInWeaponizationSystems, "Weaponization systems must be transparent.");
        _declare(WeaponRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(WeaponRule ruleType, string memory description) internal {
        covenantCount++;
        rules[covenantCount] = Rule(
            covenantCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(covenantCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    // --- Weapon case lifecycle ---
    function fileWeaponCase(string calldata grounds) external {
        covenantCount++;
        weaponCases[covenantCount] = WeaponCase(
            covenantCount,
            msg.sender,
            grounds,
            WeaponStatus.Filed,
            0,
            block.timestamp
        );

        emit WeaponFiled(covenantCount);
    }

    function beginReview(uint256 weaponId) external onlyCouncil {
        WeaponCase storage w = weaponCases[weaponId];
        require(w.status == WeaponStatus.Filed, "Not filed");
        w.status = WeaponStatus.UnderReview;
        emit WeaponStatusChanged(weaponId, WeaponStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 weaponId) external onlyCouncil {
        WeaponCase storage w = weaponCases[weaponId];
        require(w.status == WeaponStatus.UnderReview, "Not under review");
        w.status = WeaponStatus.MultiCouncilReview;
        emit WeaponStatusChanged(weaponId, WeaponStatus.MultiCouncilReview);
    }

    function confirmWeaponizationBlocked(uint256 weaponId) external onlyCouncil {
        WeaponCase storage w = weaponCases[weaponId];
        require(w.status == WeaponStatus.MultiCouncilReview, "Not in council stage");

        w.approvals++;

        if (w.approvals * 2 > councilCount && councilCount > 0) {
            w.status = WeaponStatus.WeaponizationBlocked;
            emit WeaponStatusChanged(weaponId, WeaponStatus.WeaponizationBlocked);
        }
    }

    function rejectWeaponCase(uint256 weaponId) external onlyCouncil {
        WeaponCase storage w = weaponCases[weaponId];
        require(
            w.status == WeaponStatus.Filed ||
            w.status == WeaponStatus.UnderReview ||
            w.status == WeaponStatus.MultiCouncilReview,
            "Invalid status"
        );
        w.status = WeaponStatus.Rejected;
        emit WeaponStatusChanged(weaponId, WeaponStatus.Rejected);
    }
}
