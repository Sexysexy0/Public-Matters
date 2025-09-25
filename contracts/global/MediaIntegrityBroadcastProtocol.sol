// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract MediaIntegrityBroadcastProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct BroadcastCorridor {
        uint256 id;
        string mediaOutlet; // e.g., "ChannelX", "NewsNetPH"
        string suppressedEvent; // e.g., "Rally in Manila", "Farmers protest", "PWD march"
        bool overrideBlocked;
        bool biasNeutralized;
        bool civicBroadcastActivated;
        string emotionalTag; // e.g., "Suppressed voice restored"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => BroadcastCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event BroadcastCorridorActivated(uint256 indexed id, string mediaOutlet, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateBroadcastCorridor(
        string calldata mediaOutlet,
        string calldata suppressedEvent,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = BroadcastCorridor({
            id: id,
            mediaOutlet: mediaOutlet,
            suppressedEvent: suppressedEvent,
            overrideBlocked: true,
            biasNeutralized: true,
            civicBroadcastActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit BroadcastCorridorActivated(id, mediaOutlet, emotionalTag);
    }

    function getBroadcastCorridor(uint256 id) external view returns (BroadcastCorridor memory) {
        return corridors[id];
    }
}
