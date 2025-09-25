// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title TaxPurificationProtocol
/// @notice Ritualizes tax exemption for essentials and vulnerable sectors, redirects fiscal burden to enterprise and luxury corridors, and anchors emotional consequence
/// @dev Anchors dignity-certified taxation, restoration clause, and planetary fiscal clarity

contract TaxPurificationProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct TaxCorridor {
        uint256 id;
        string itemOrSector; // e.g., "Rice", "Small business", "Luxury yacht", "Corporate profit"
        string category; // e.g., "Essential", "Enterprise", "Luxury", "Vulnerable"
        bool taxExempt;
        bool burdenRedirected;
        bool dignityCertified;
        string emotionalTag; // e.g., "Tax corridor purified"
        string restorationClause; // e.g., "We commit to dignity-certified taxation and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => TaxCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event TaxCorridorActivated(uint256 indexed id, string itemOrSector, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateTaxCorridor(
        string calldata itemOrSector,
        string calldata category,
        bool taxExempt,
        bool burdenRedirected,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = TaxCorridor({
            id: id,
            itemOrSector: itemOrSector,
            category: category,
            taxExempt: taxExempt,
            burdenRedirected: burdenRedirected,
            dignityCertified: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit TaxCorridorActivated(id, itemOrSector, emotionalTag);
    }

    function getTaxCorridor(uint256 id) external view returns (TaxCorridor memory) {
        return corridors[id];
    }
}
