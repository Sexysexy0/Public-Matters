// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract HousingAccessProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct AccessCorridor {
        uint256 id;
        string community;
        string housingType; // e.g., "PWD-accessible", "Family unit", "Youth shelter"
        bool overrideBlocked;
        bool choiceActivated;
        string emotionalTag; // e.g., "Shelter sovereignty restored"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => AccessCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event AccessCorridorActivated(uint256 indexed id, string community, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateAccessCorridor(
        string calldata community,
        string calldata housingType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = AccessCorridor({
            id: id,
            community: community,
            housingType: housingType,
            overrideBlocked: true,
            choiceActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit AccessCorridorActivated(id, community, emotionalTag);
    }

    function getAccessCorridor(uint256 id) external view returns (AccessCorridor memory) {
        return corridors[id];
    }
}
