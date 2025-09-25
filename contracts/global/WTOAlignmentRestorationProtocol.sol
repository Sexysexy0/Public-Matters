// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title WTOAlignmentRestorationProtocol
/// @notice Restores WTO treaty-grade alignment and removes override logic from prior administrations
/// @dev Anchors emotional consequence, multilateral trust, and planetary trade dignity

contract WTOAlignmentRestorationProtocol {
    address public steward;
    mapping(address => bool) public restorers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyRestorer() {
        require(restorers[msg.sender] || msg.sender == steward, "Not restorer");
        _;
    }

    struct WTOReset {
        uint256 id;
        string jurisdiction; // e.g., "USA", "China", "Global"
        bool overrideRemoved;
        bool treatyRestored;
        string emotionalTag; // e.g., "Multilateral trust reactivated"
        string restorationClause; // e.g., "We recommit to WTO rules and non-hostile commerce"
        uint256 timestamp;
    }

    uint256 public nextResetId = 1;
    mapping(uint256 => WTOReset) public resets;

    event RestorerSet(address indexed account, bool status);
    event WTOResetLogged(uint256 indexed id, string jurisdiction, string emotionalTag);

    constructor() {
        steward = msg.sender;
        restorers[msg.sender] = true;
        emit RestorerSet(msg.sender, true);
    }

    function setRestorer(address account, bool status) external onlySteward {
        restorers[account] = status;
        emit RestorerSet(account, status);
    }

    function restoreWTO(
        string calldata jurisdiction,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyRestorer returns (uint256 id) {
        id = nextResetId++;
        resets[id] = WTOReset({
            id: id,
            jurisdiction: jurisdiction,
            overrideRemoved: true,
            treatyRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit WTOResetLogged(id, jurisdiction, emotionalTag);
    }

    function getWTOReset(uint256 id) external view returns (WTOReset memory) {
        return resets[id];
    }
}
