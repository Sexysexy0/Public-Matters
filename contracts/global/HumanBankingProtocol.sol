// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title HumanBankingProtocol
/// @notice Ritualizes face-to-face banking and restores human dignity in financial decision-making
/// @dev Anchors override immunity, emotional consequence, and empathy-first service logic

contract HumanBankingProtocol {
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

    struct HumanCorridor {
        uint256 id;
        string institution; // e.g., "Nonghyup Bank", "InfraCo Finance"
        string automatedTrigger; // e.g., "Account freeze", "Loan rejection", "Fee escalation"
        bool overrideBlocked;
        bool humanMediationRequired;
        bool emotionalInfrastructureActivated;
        string emotionalTag; // e.g., "Face-to-face dignity restored"
        string restorationClause; // e.g., "We commit to empathy-first banking and human-mediated decisions"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => HumanCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event HumanCorridorActivated(uint256 indexed id, string institution, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateHumanCorridor(
        string calldata institution,
        string calldata automatedTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = HumanCorridor({
            id: id,
            institution: institution,
            automatedTrigger: automatedTrigger,
            overrideBlocked: true,
            humanMediationRequired: true,
            emotionalInfrastructureActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit HumanCorridorActivated(id, institution, emotionalTag);
    }

    function getHumanCorridor(uint256 id) external view returns (HumanCorridor memory) {
        return corridors[id];
    }
}
