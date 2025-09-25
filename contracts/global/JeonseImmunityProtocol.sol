// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract JeonseImmunityProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct JeonseCorridor {
        uint256 id;
        string propertyId;
        string fraudTrigger; // e.g., "Inflated appraisal", "Ghost landlord"
        bool overrideBlocked;
        bool tenantProtectionActivated;
        string emotionalTag; // e.g., "Tenant dignity restored"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => JeonseCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event JeonseCorridorActivated(uint256 indexed id, string propertyId, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateJeonseCorridor(
        string calldata propertyId,
        string calldata fraudTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = JeonseCorridor({
            id: id,
            propertyId: propertyId,
            fraudTrigger: fraudTrigger,
            overrideBlocked: true,
            tenantProtectionActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit JeonseCorridorActivated(id, propertyId, emotionalTag);
    }

    function getJeonseCorridor(uint256 id) external view returns (JeonseCorridor memory) {
        return corridors[id];
    }
}
