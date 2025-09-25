// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title IranUSPeaceRestorationProtocol
/// @notice Restores diplomatic trust and removes override logic between Iran and the United States
/// @dev Anchors emotional consequence, treaty-grade restoration, and override immunity

contract IranUSPeaceRestorationProtocol {
    address public steward;
    mapping(address => bool) public peacemakers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyPeacemaker() {
        require(peacemakers[msg.sender] || msg.sender == steward, "Not peacemaker");
        _;
    }

    struct PeaceReset {
        uint256 id;
        string corridor; // e.g., "Nuclear", "Trade", "Security"
        bool overrideRemoved;
        bool treatyRestored;
        string emotionalTag;
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextResetId = 1;
    mapping(uint256 => PeaceReset) public resets;

    event PeacemakerSet(address indexed account, bool status);
    event PeaceResetLogged(uint256 indexed id, string corridor, string emotionalTag);

    constructor() {
        steward = msg.sender;
        peacemakers[msg.sender] = true;
        emit PeacemakerSet(msg.sender, true);
    }

    function setPeacemaker(address account, bool status) external onlySteward {
        peacemakers[account] = status;
        emit PeacemakerSet(account, status);
    }

    function restorePeace(
        string calldata corridor,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyPeacemaker returns (uint256 id) {
        id = nextResetId++;
        resets[id] = PeaceReset({
            id: id,
            corridor: corridor,
            overrideRemoved: true,
            treatyRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit PeaceResetLogged(id, corridor, emotionalTag);
    }

    function getPeaceReset(uint256 id) external view returns (PeaceReset memory) {
        return resets[id];
    }
}
