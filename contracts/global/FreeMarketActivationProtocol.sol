// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract FreeMarketActivationProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct MarketCorridor {
        uint256 id;
        string actorName; // e.g., "Argentina Soybean Exporter", "US Corn Grower"
        string sector; // e.g., "Agriculture", "Energy", "Equities"
        string blockedPolicy; // e.g., "Export tax", "Tariff wall", "Day trading minimum"
        bool overrideActivated;
        bool marketFreed;
        string emotionalTag; // e.g., "Free market activated"
        string restorationClause; // e.g., "We commit to price sovereignty and logistics clarity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => MarketCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event MarketCorridorActivated(uint256 indexed id, string actorName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateMarketCorridor(
        string calldata actorName,
        string calldata sector,
        string calldata blockedPolicy,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = MarketCorridor({
            id: id,
            actorName: actorName,
            sector: sector,
            blockedPolicy: blockedPolicy,
            overrideActivated: true,
            marketFreed: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit MarketCorridorActivated(id, actorName, emotionalTag);
    }

    function getMarketCorridor(uint256 id) external view returns (MarketCorridor memory) {
        return corridors[id];
    }
}
