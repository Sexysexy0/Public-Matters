// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract TalentPoachingAuditProtocol {
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

    struct PoachingCorridor {
        uint256 id;
        string recruitingEntity; // e.g., "Meta", "OpenAI", "xAI"
        string poachingTrigger; // e.g., "$100M signing bonus", "Unsolicited offer"
        bool ethicsAuditActivated;
        bool emotionalFalloutTagged;
        string emotionalTag; // e.g., "Recruitment dignity breached"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => PoachingCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event PoachingCorridorActivated(uint256 indexed id, string recruitingEntity, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activatePoachingCorridor(
        string calldata recruitingEntity,
        string calldata poachingTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = PoachingCorridor({
            id: id,
            recruitingEntity: recruitingEntity,
            poachingTrigger: poachingTrigger,
            ethicsAuditActivated: true,
            emotionalFalloutTagged: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit PoachingCorridorActivated(id, recruitingEntity, emotionalTag);
    }

    function getPoachingCorridor(uint256 id) external view returns (PoachingCorridor memory) {
        return corridors[id];
    }
}
