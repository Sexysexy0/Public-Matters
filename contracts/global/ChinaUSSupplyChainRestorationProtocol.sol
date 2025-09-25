// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ChinaUSSupplyChainRestorationProtocol
/// @notice Ritualizes restoration of China–U.S. supply chain and activates global investor deployment
/// @dev Anchors override immunity, cargo integrity, and planetary consequence

contract ChinaUSSupplyChainRestorationProtocol {
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

    struct SupplyChainCorridor {
        uint256 id;
        string investorName;
        string originCountry; // e.g., "Philippines", "Germany", "Brazil"
        string destinationCountry; // e.g., "China", "United States"
        string cargoType; // e.g., "Semiconductors", "Medical supplies", "Green tech"
        bool overrideActivated;
        bool logisticsRestored;
        bool treatyGradeCommitted;
        string emotionalTag; // e.g., "Global logistics restored"
        string restorationClause; // e.g., "We commit to ethical delivery and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => SupplyChainCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event SupplyChainCorridorActivated(uint256 indexed id, string investorName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateSupplyChainCorridor(
        string calldata investorName,
        string calldata originCountry,
        string calldata destinationCountry,
        string calldata cargoType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = SupplyChainCorridor({
            id: id,
            investorName: investorName,
            originCountry: originCountry,
            destinationCountry: destinationCountry,
            cargoType: cargoType,
            overrideActivated: true,
            logisticsRestored: true,
            treatyGradeCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit SupplyChainCorridorActivated(id, investorName, emotionalTag);
    }

    function getSupplyChainCorridor(uint256 id) external view returns (SupplyChainCorridor memory) {
        return corridors[id];
    }
}
