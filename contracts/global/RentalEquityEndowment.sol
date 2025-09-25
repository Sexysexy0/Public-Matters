// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract RentalEquityEndowment {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct EndowmentCorridor {
        uint256 id;
        string projectName; // e.g., "Seoul Dignity Housing"
        string fundingSource; // e.g., "NPS", "Diaspora Cooperative"
        bool overrideBlocked;
        bool equityActivated;
        string emotionalTag; // e.g., "Housing dignity funded"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => EndowmentCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event EndowmentCorridorActivated(uint256 indexed id, string projectName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateEndowmentCorridor(
        string calldata projectName,
        string calldata fundingSource,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = EndowmentCorridor({
            id: id,
            projectName: projectName,
            fundingSource: fundingSource,
            overrideBlocked: true,
            equityActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit EndowmentCorridorActivated(id, projectName, emotionalTag);
    }

    function getEndowmentCorridor(uint256 id) external view returns (EndowmentCorridor memory) {
        return corridors[id];
    }
}
