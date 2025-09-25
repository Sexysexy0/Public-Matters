// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ChinaUSRestorationTreaty
/// @notice Ritualizes climate cooperation and tariff rollback between China and the United States
/// @dev Anchors override immunity, emotional consequence, and treaty-grade restoration logic

contract ChinaUSRestorationTreaty {
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

    struct TreatyCorridor {
        uint256 id;
        string countryA; // e.g., "China"
        string countryB; // e.g., "United States"
        string climatePledge; // e.g., "Cut emissions by 10% by 2035"
        string tariffRollback; // e.g., "Remove 15% steel tariff"
        bool overrideActivated;
        bool denialBlocked;
        bool stewardshipCommitted;
        string emotionalTag; // e.g., "Planetary care activated"
        string restorationClause; // e.g., "We commit to mutual prosperity and climate consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => TreatyCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event TreatyCorridorActivated(uint256 indexed id, string countryA, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateTreatyCorridor(
        string calldata countryA,
        string calldata countryB,
        string calldata climatePledge,
        string calldata tariffRollback,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = TreatyCorridor({
            id: id,
            countryA: countryA,
            countryB: countryB,
            climatePledge: climatePledge,
            tariffRollback: tariffRollback,
            overrideActivated: true,
            denialBlocked: true,
            stewardshipCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit TreatyCorridorActivated(id, countryA, emotionalTag);
    }

    function getTreatyCorridor(uint256 id) external view returns (TreatyCorridor memory) {
        return corridors[id];
    }
}
