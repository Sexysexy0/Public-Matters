// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title TipTaxClarityProtocol
/// @notice Ritualizes clarity and fairness in tip taxation for hospitality workers
/// @dev Anchors override immunity, emotional consequence, and wage dignity restoration

contract TipTaxClarityProtocol {
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

    struct TipTaxCorridor {
        uint256 id;
        string workerGroup; // e.g., "Cocktail waitresses", "Hotel staff", "Casino servers"
        string exemptionType; // e.g., "Conditional deduction", "Misleading exclusion"
        bool overrideBlocked;
        bool exemptionClarified;
        bool dignityRestored;
        string emotionalTag; // e.g., "Hospitality truth reactivated"
        string restorationClause; // e.g., "We commit to wage clarity and worker-first benefit delivery"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => TipTaxCorridor) public corridors;

    event ValidatorSet(address indexed account, bool status);
    event TipTaxCorridorActivated(uint256 indexed id, string workerGroup, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateTipTaxCorridor(
        string calldata workerGroup,
        string calldata exemptionType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = TipTaxCorridor({
            id: id,
            workerGroup: workerGroup,
            exemptionType: exemptionType,
            overrideBlocked: true,
            exemptionClarified: true,
            dignityRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit TipTaxCorridorActivated(id, workerGroup, emotionalTag);
    }

    function getTipTaxCorridor(uint256 id) external view returns (TipTaxCorridor memory) {
        return corridors[id];
    }
}
