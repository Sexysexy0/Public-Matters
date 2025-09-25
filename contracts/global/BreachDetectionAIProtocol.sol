// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BreachDetectionAIProtocol {
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

    struct DetectionCorridor {
        uint256 id;
        string institution;
        string breachType; // e.g., "Bank hacking", "Internal sabotage"
        bool overrideBlocked;
        bool aiDetectionActivated;
        bool immunityGranted;
        string emotionalTag; // e.g., "Breach corridor neutralized"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => DetectionCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event DetectionCorridorActivated(uint256 indexed id, string institution, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateDetectionCorridor(
        string calldata institution,
        string calldata breachType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = DetectionCorridor({
            id: id,
            institution: institution,
            breachType: breachType,
            overrideBlocked: true,
            aiDetectionActivated: true,
            immunityGranted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit DetectionCorridorActivated(id, institution, emotionalTag);
    }

    function getDetectionCorridor(uint256 id) external view returns (DetectionCorridor memory) {
        return corridors[id];
    }
}
