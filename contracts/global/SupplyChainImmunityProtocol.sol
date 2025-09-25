// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title SupplyChainImmunityProtocol
/// @notice Ritualizes protection for supply chains, tags weak vendor links, and anchors restoration and emotional consequence for breached logistics corridors
/// @dev Anchors operational trust, breach immunity, and planetary consequence

contract SupplyChainImmunityProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct SupplyCorridor {
        uint256 id;
        string vendorName; // e.g., "LogiLink", "EdgeSoft", "ParcelNode"
        string breachType; // e.g., "Credential theft", "Ransomware", "Software backdoor"
        string sector; // e.g., "Healthcare", "Finance", "Manufacturing"
        bool breachTagged;
        bool immunityActivated;
        bool restorationTriggered;
        string emotionalTag; // e.g., "Supply corridor breached"
        string restorationClause; // e.g., "We commit to operational trust and planetary logistics clarity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => SupplyCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event SupplyCorridorActivated(uint256 indexed id, string vendorName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateSupplyCorridor(
        string calldata vendorName,
        string calldata breachType,
        string calldata sector,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = SupplyCorridor({
            id: id,
            vendorName: vendorName,
            breachType: breachType,
            sector: sector,
            breachTagged: true,
            immunityActivated: true,
            restorationTriggered: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit SupplyCorridorActivated(id, vendorName, emotionalTag);
    }

    function getSupplyCorridor(uint256 id) external view returns (SupplyCorridor memory) {
        return corridors[id];
    }
}
