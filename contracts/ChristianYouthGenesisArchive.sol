// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChristianYouthGenesisArchive
/// @notice Covenant contract to encode genesis-level archive, root ledger of all governance layers
contract ChristianYouthGenesisArchive {
    address public owner;

    struct GenesisEntry {
        uint256 eternalRecordId; // linked to ChristianYouthEternalLedger entry
        string domain;           // e.g. "Masculine Dignity", "Community Purpose", "Truth and Courage"
        string originNote;       // genesis-level archival note
        uint256 timestamp;
    }

    GenesisEntry[] public genesisEntries;

    event GenesisArchived(uint256 eternalRecordId, string domain, string originNote, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Archive eternal record into genesis root ledger
    function archiveGenesis(uint256 eternalRecordId, string memory domain, string memory originNote) public onlyOwner {
        GenesisEntry memory newEntry = GenesisEntry(eternalRecordId, domain, originNote, block.timestamp);
        genesisEntries.push(newEntry);
        emit GenesisArchived(eternalRecordId, domain, originNote, block.timestamp);
    }

    function getGenesisEntry(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        GenesisEntry memory g = genesisEntries[index];
        return (g.eternalRecordId, g.domain, g.originNote, g.timestamp);
    }

    function getGenesisCount() public view returns (uint256) {
        return genesisEntries.length;
    }
}
