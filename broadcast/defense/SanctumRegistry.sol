// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title SanctumRegistry.sol
/// @dev Mythic registry of protected zones with lore, emotional APR, and damay clause

contract SanctumRegistry {
    address public steward;

    struct Sanctum {
        string name;
        string lore;
        string ecologicalTag;
        string ancestralTag;
        uint256 emotionalAPR;
        bool isProtected;
    }

    mapping(bytes32 => Sanctum) public sanctums;
    bytes32[] public sanctumList;

    event SanctumRegistered(bytes32 indexed zoneId, string name, string lore);
    event SanctumUpdated(bytes32 indexed zoneId, string field, string newValue);
    event ProtectionActivated(bytes32 indexed zoneId);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Register a new sanctum with full mythic metadata
    function registerSanctum(
        bytes32 zoneId,
        string memory name,
        string memory lore,
        string memory ecologicalTag,
        string memory ancestralTag,
        uint256 emotionalAPR
    ) public onlySteward {
        Sanctum memory newSanctum = Sanctum({
            name: name,
            lore: lore,
            ecologicalTag: ecologicalTag,
            ancestralTag: ancestralTag,
            emotionalAPR: emotionalAPR,
            isProtected: true
        });

        sanctums[zoneId] = newSanctum;
        sanctumList.push(zoneId);
        emit SanctumRegistered(zoneId, name, lore);
        emit ProtectionActivated(zoneId);
    }

    /// @notice Update lore or tags if needed
    function updateSanctumLore(bytes32 zoneId, string memory newLore) public onlySteward {
        sanctums[zoneId].lore = newLore;
        emit SanctumUpdated(zoneId, "lore", newLore);
    }

    /// @notice Retrieve full sanctum metadata
    function getSanctum(bytes32 zoneId) public view returns (Sanctum memory) {
        return sanctums[zoneId];
    }

    /// @notice List all registered sanctum zone IDs
    function listSanctums() public view returns (bytes32[] memory) {
        return sanctumList;
    }
}
