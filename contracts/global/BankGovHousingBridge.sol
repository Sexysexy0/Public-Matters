// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BankGovHousingBridge {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct BridgeCorridor {
        uint256 id;
        string bank;
        string governmentAgency;
        string housingInventory; // e.g., "Foreclosed units", "Idle apartments"
        bool overrideBlocked;
        bool bridgeActivated;
        string emotionalTag; // e.g., "Housing alliance sealed"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => BridgeCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event BridgeCorridorActivated(uint256 indexed id, string bank, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateBridgeCorridor(
        string calldata bank,
        string calldata governmentAgency,
        string calldata housingInventory,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = BridgeCorridor({
            id: id,
            bank: bank,
            governmentAgency: governmentAgency,
            housingInventory: housingInventory,
            overrideBlocked: true,
            bridgeActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit BridgeCorridorActivated(id, bank, emotionalTag);
    }

    function getBridgeCorridor(uint256 id) external view returns (BridgeCorridor memory) {
        return corridors[id];
    }
}
