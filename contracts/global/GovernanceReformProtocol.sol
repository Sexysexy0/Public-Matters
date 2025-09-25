// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GovernanceReformProtocol
/// @notice Consolidates recent reforms and transfers operational power to investors
/// @dev Anchors override immunity, ethical guardrails, and restoration clauses

contract GovernanceReformProtocol {
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

    struct ReformCorridor {
        uint256 id;
        string investorName;
        string companyName;
        string reformScope; // e.g., "Housing", "Media", "Trade", "Investment"
        bool overrideActivated;
        bool investorManagementGranted;
        bool policyNeutralized;
        string emotionalTag; // e.g., "Investor governance activated"
        string restorationClause; // e.g., "We commit to ethical autonomy and prosperity without harm"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => ReformCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event ReformCorridorActivated(uint256 indexed id, string companyName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateReformCorridor(
        string calldata investorName,
        string calldata companyName,
        string calldata reformScope,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = ReformCorridor({
            id: id,
            investorName: investorName,
            companyName: companyName,
            reformScope: reformScope,
            overrideActivated: true,
            investorManagementGranted: true,
            policyNeutralized: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ReformCorridorActivated(id, companyName, emotionalTag);
    }

    function getReformCorridor(uint256 id) external view returns (ReformCorridor memory) {
        return corridors[id];
    }
}
