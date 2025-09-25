// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ShareholderRestorationProtocol {
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

    struct RestorationCorridor {
        uint256 id;
        string institution;
        string damageTrigger; // e.g., "80B loss", "2% recovery rate"
        bool overrideBlocked;
        bool dignityRestored;
        bool emotionalMappingActivated;
        string emotionalTag; // e.g., "Shareholder dignity restored"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => RestorationCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event RestorationCorridorActivated(uint256 indexed id, string institution, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateRestorationCorridor(
        string calldata institution,
        string calldata damageTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = RestorationCorridor({
            id: id,
            institution: institution,
            damageTrigger: damageTrigger,
            overrideBlocked: true,
            dignityRestored: true,
            emotionalMappingActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit RestorationCorridorActivated(id, institution, emotionalTag);
    }

    function getRestorationCorridor(uint256 id) external view returns (RestorationCorridor memory) {
        return corridors[id];
    }
}
