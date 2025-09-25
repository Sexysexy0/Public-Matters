// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract PensionRepatriationProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct RepatriationCorridor {
        uint256 id;
        string fundName;
        string reinvestmentTarget; // e.g., "Seoul rental housing", "PWD-accessible units"
        bool overrideBlocked;
        bool reinvestmentCommitted;
        string emotionalTag; // e.g., "Domestic reinvestment activated"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => RepatriationCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event RepatriationCorridorActivated(uint256 indexed id, string fundName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateRepatriationCorridor(
        string calldata fundName,
        string calldata reinvestmentTarget,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = RepatriationCorridor({
            id: id,
            fundName: fundName,
            reinvestmentTarget: reinvestmentTarget,
            overrideBlocked: true,
            reinvestmentCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit RepatriationCorridorActivated(id, fundName, emotionalTag);
    }

    function getRepatriationCorridor(uint256 id) external view returns (RepatriationCorridor memory) {
        return corridors[id];
    }
}
