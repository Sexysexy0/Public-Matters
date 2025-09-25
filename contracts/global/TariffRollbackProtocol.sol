// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title TariffRollbackProtocol
/// @notice Ritualizes the global removal of tariffs and trade hostility
/// @dev Anchors emotional consequence, treaty-grade restoration, and planetary trade dignity

contract TariffRollbackProtocol {
    address public steward;
    mapping(address => bool) public liberators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyLiberator() {
        require(liberators[msg.sender] || msg.sender == steward, "Not liberator");
        _;
    }

    struct TariffRollback {
        uint256 id;
        string originNation;
        string destinationNation;
        string assetClass; // e.g., "Tech", "Agriculture", "Energy"
        bool tariffRemoved;
        string emotionalTag; // e.g., "Trade dignity restored"
        string restorationClause; // e.g., "We commit to non-hostile commerce"
        uint256 timestamp;
    }

    uint256 public nextRollbackId = 1;
    mapping(uint256 => TariffRollback) public rollbacks;

    event LiberatorSet(address indexed account, bool status);
    event TariffRemoved(uint256 indexed id, string originNation, string destinationNation, string emotionalTag);

    constructor() {
        steward = msg.sender;
        liberators[msg.sender] = true;
        emit LiberatorSet(msg.sender, true);
    }

    function setLiberator(address account, bool status) external onlySteward {
        liberators[account] = status;
        emit LiberatorSet(account, status);
    }

    function removeTariff(
        string calldata originNation,
        string calldata destinationNation,
        string calldata assetClass,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyLiberator returns (uint256 id) {
        id = nextRollbackId++;
        rollbacks[id] = TariffRollback({
            id: id,
            originNation: originNation,
            destinationNation: destinationNation,
            assetClass: assetClass,
            tariffRemoved: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit TariffRemoved(id, originNation, destinationNation, emotionalTag);
    }

    function getRollback(uint256 id) external view returns (TariffRollback memory) {
        return rollbacks[id];
    }
}
