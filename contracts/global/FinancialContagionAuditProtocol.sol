// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title FinancialContagionAuditProtocol
/// @notice Ritualizes audit of catastrophic financial breaches and anchors systemic immunity
/// @dev Anchors override protection, emotional consequence, and shareholder dignity restoration

contract FinancialContagionAuditProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender] || msg.sender == steward, "Not validator");
        _;
    }

    struct ContagionCorridor {
        uint256 id;
        string institution; // e.g., "Nonghyup Bank"
        string breachTrigger; // e.g., "Bank hacking", "Security vulnerability", "Financial illness"
        bool overrideBlocked;
        bool immunityActivated;
        bool shareholderDignityRestored;
        string emotionalTag; // e.g., "Confidence collapse detected"
        string restorationClause; // e.g., "We commit to forensic transparency and systemic restoration"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => ContagionCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event ContagionCorridorActivated(uint256 indexed id, string institution, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateContagionCorridor(
        string calldata institution,
        string calldata breachTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = ContagionCorridor({
            id: id,
            institution: institution,
            breachTrigger: breachTrigger,
            overrideBlocked: true,
            immunityActivated: true,
            shareholderDignityRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ContagionCorridorActivated(id, institution, emotionalTag);
    }

    function getContagionCorridor(uint256 id) external view returns (ContagionCorridor memory) {
        return corridors[id];
    }
}
