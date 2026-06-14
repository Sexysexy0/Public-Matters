// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LootEconomyLedger
/// @notice Ledger covenant to balance loot spawn rates in Solo Mode
contract LootEconomyLedger {
    address public overseer;
    uint256 public entryCount;

    struct LootRecord {
        uint256 id;
        string resource;   // ammo, plates, medkits
        uint256 spawnRate; // percentage or frequency
        string feedback;   // player comment summary
        string notes;      // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => LootRecord) public records;

    event LootLogged(uint256 indexed id, string resource, uint256 spawnRate, string feedback);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs loot spawn record
    function logLoot(string calldata resource, uint256 spawnRate, string calldata feedback, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = LootRecord({
            id: entryCount,
            resource: resource,
            spawnRate: spawnRate,
            feedback: feedback,
            notes: notes,
            timestamp: block.timestamp
        });
        emit LootLogged(entryCount, resource, spawnRate, feedback);
    }

    /// @notice Citizens can view loot spawn records
    function viewLoot(uint256 id) external view returns (LootRecord memory) {
        return records[id];
    }
}
