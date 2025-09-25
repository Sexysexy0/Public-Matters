// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract TariffPowerReallocationProtocol {
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

    struct ReallocationCorridor {
        uint256 id;
        string originAuthority; // e.g., "Executive Branch"
        string destinationAuthority; // e.g., "Congress"
        string affectedPolicy; // e.g., "Tariff imposition", "Trade sanctions"
        bool overrideActivated;
        bool legislativeControlGranted;
        string emotionalTag; // e.g., "Legislative clarity activated"
        string restorationClause; // e.g., "We commit to transparent trade and democratic consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => ReallocationCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event ReallocationCorridorActivated(uint256 indexed id, string affectedPolicy, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateReallocationCorridor(
        string calldata originAuthority,
        string calldata destinationAuthority,
        string calldata affectedPolicy,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = ReallocationCorridor({
            id: id,
            originAuthority: originAuthority,
            destinationAuthority: destinationAuthority,
            affectedPolicy: affectedPolicy,
            overrideActivated: true,
            legislativeControlGranted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ReallocationCorridorActivated(id, affectedPolicy, emotionalTag);
    }

    function getReallocationCorridor(uint256 id) external view returns (ReallocationCorridor memory) {
        return corridors[id];
    }
}
