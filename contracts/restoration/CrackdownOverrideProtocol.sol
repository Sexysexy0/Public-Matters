// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CrackdownOverrideProtocol
/// @notice Cancels or overrides punitive crackdowns based on dignity breach, livelihood impact, and civic restraint
/// @dev Anchors breach-tier tagging, emotional consequence, and restorative broadcast

contract CrackdownOverrideProtocol {
    address public steward;
    mapping(address => bool) public auditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    enum EnforcementStatus {
        Proposed,
        Blocked,
        Approved,
        BreachFlagged
    }

    struct EnforcementAttempt {
        uint256 id;
        address target;
        string activity; // e.g., "Street vending", "Informal trade", "Unlicensed sale"
        string jurisdiction;
        EnforcementStatus status;
        string breachTier;
        string emotionalTag;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextAttemptId = 1;
    mapping(uint256 => EnforcementAttempt) public registry;
    mapping(address => uint256[]) public targetAttempts;

    event AuditorSet(address indexed account, bool status);
    event EnforcementFiled(uint256 indexed id, address indexed target, string activity);
    event CrackdownBlocked(uint256 indexed id, string breachTier, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function fileEnforcementAttempt(
        address target,
        string calldata activity,
        string calldata jurisdiction
    ) external onlyAuditor returns (uint256 id) {
        id = nextAttemptId++;
        registry[id] = EnforcementAttempt({
            id: id,
            target: target,
            activity: activity,
            jurisdiction: jurisdiction,
            status: EnforcementStatus.Proposed,
            breachTier: "",
            emotionalTag: "",
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        targetAttempts[target].push(id);
        emit EnforcementFiled(id, target, activity);
    }

    function blockCrackdown(uint256 id, string calldata breachTier, string calldata emotionalTag) external onlyAuditor {
        EnforcementAttempt storage ea = registry[id];
        require(ea.id != 0, "Attempt not found");
        ea.status = EnforcementStatus.Blocked;
        ea.breachTier = breachTier;
        ea.emotionalTag = emotionalTag;
        ea.updatedAt = block.timestamp;
        emit CrackdownBlocked(id, breachTier, emotionalTag);
    }

    function getEnforcementAttempt(uint256 id) external view returns (EnforcementAttempt memory) {
        return registry[id];
    }

    function listTargetAttempts(address target) external view returns (uint256[] memory) {
        return targetAttempts[target];
    }
}
