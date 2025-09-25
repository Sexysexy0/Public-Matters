// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract HumanHiringProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct HiringCorridor {
        uint256 id;
        string companyName;
        string replacedSystem; // e.g., "AI hiring tool", "Algorithmic filter"
        bool overrideActivated;
        bool humanHiringCommitted;
        string emotionalTag; // e.g., "Labor dignity restored"
        string restorationClause; // e.g., "We commit to human-led hiring and bias immunity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => HiringCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event HiringCorridorActivated(uint256 indexed id, string companyName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateHiringCorridor(
        string calldata companyName,
        string calldata replacedSystem,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = HiringCorridor({
            id: id,
            companyName: companyName,
            replacedSystem: replacedSystem,
            overrideActivated: true,
            humanHiringCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit HiringCorridorActivated(id, companyName, emotionalTag);
    }

    function getHiringCorridor(uint256 id) external view returns (HiringCorridor memory) {
        return corridors[id];
    }
}
