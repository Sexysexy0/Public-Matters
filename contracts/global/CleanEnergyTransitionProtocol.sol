// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract CleanEnergyTransitionProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct TransitionCorridor {
        uint256 id;
        string investorName;
        string originCountry;
        string energyType; // e.g., "Solar", "Wind", "Battery Storage"
        string replacedCorridor; // e.g., "Coal", "Oil", "Gas"
        bool overrideActivated;
        bool cleanEnergyCommitted;
        string emotionalTag; // e.g., "Planetary care activated"
        string restorationClause; // e.g., "We commit to clean energy and climate consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => TransitionCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event TransitionCorridorActivated(uint256 indexed id, string investorName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateTransitionCorridor(
        string calldata investorName,
        string calldata originCountry,
        string calldata energyType,
        string calldata replacedCorridor,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = TransitionCorridor({
            id: id,
            investorName: investorName,
            originCountry: originCountry,
            energyType: energyType,
            replacedCorridor: replacedCorridor,
            overrideActivated: true,
            cleanEnergyCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit TransitionCorridorActivated(id, investorName, emotionalTag);
    }

    function getTransitionCorridor(uint256 id) external view returns (TransitionCorridor memory) {
        return corridors[id];
    }
}
