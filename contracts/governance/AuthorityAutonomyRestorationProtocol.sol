// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title AuthorityAutonomyRestorationProtocol
/// @notice Removes override constraints from officials and enables reparations funded by public contribution
/// @dev Anchors emotional consequence, apology clause, and operational dignity

contract AuthorityAutonomyRestorationProtocol {
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

    struct RestorationMandate {
        uint256 id;
        string officialName;
        string jurisdiction; // e.g., "Department of Foreign Affairs", "Office of the Mayor"
        bool overrideRemoved;
        bool autonomyRestored;
        bool reparationsEnabled;
        string emotionalTag;
        string apologyClause;
        uint256 timestamp;
    }

    uint256 public nextMandateId = 1;
    mapping(uint256 => RestorationMandate) public mandates;

    event LiberatorSet(address indexed account, bool status);
    event MandateActivated(uint256 indexed id, string officialName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        liberators[msg.sender] = true;
        emit LiberatorSet(msg.sender, true);
    }

    function setLiberator(address account, bool status) external onlySteward {
        liberators[account] = status;
        emit LiberatorSet(account, status);
    }

    function activateMandate(
        string calldata officialName,
        string calldata jurisdiction,
        string calldata emotionalTag,
        string calldata apologyClause
    ) external onlyLiberator returns (uint256 id) {
        id = nextMandateId++;
        mandates[id] = RestorationMandate({
            id: id,
            officialName: officialName,
            jurisdiction: jurisdiction,
            overrideRemoved: true,
            autonomyRestored: true,
            reparationsEnabled: true,
            emotionalTag: emotionalTag,
            apologyClause: apologyClause,
            timestamp: block.timestamp
        });
        emit MandateActivated(id, officialName, emotionalTag);
    }

    function getMandate(uint256 id) external view returns (RestorationMandate memory) {
        return mandates[id];
    }
}
