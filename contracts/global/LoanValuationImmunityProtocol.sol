// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract LoanValuationImmunityProtocol {
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

    struct ValuationCorridor {
        uint256 id;
        string institution;
        string appraisalTrigger; // e.g., "Inflated mortgage valuation"
        bool overrideBlocked;
        bool ethicsActivated;
        bool immunityGranted;
        string emotionalTag; // e.g., "Valuation ethics restored"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => ValuationCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event ValuationCorridorActivated(uint256 indexed id, string institution, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateValuationCorridor(
        string calldata institution,
        string calldata appraisalTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = ValuationCorridor({
            id: id,
            institution: institution,
            appraisalTrigger: appraisalTrigger,
            overrideBlocked: true,
            ethicsActivated: true,
            immunityGranted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ValuationCorridorActivated(id, institution, emotionalTag);
    }

    function getValuationCorridor(uint256 id) external view returns (ValuationCorridor memory) {
        return corridors[id];
    }
}
