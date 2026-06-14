// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CrossModeIntegrationLedger
/// @notice Ledger covenant to record proposals for BR map integration into other game modes
contract CrossModeIntegrationLedger {
    address public overseer;
    uint256 public entryCount;

    struct IntegrationRecord {
        uint256 id;
        string map;        // e.g., Widow's Bay, Golmud
        string targetMode; // Conquest, 50v50, Obliteration
        string feedback;   // player suggestion summary
        string notes;      // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => IntegrationRecord) public records;

    event IntegrationLogged(uint256 indexed id, string map, string targetMode, string feedback);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs integration proposal
    function logIntegration(string calldata map, string calldata targetMode, string calldata feedback, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = IntegrationRecord({
            id: entryCount,
            map: map,
            targetMode: targetMode,
            feedback: feedback,
            notes: notes,
            timestamp: block.timestamp
        });
        emit IntegrationLogged(entryCount, map, targetMode, feedback);
    }

    /// @notice Citizens can view integration records
    function viewIntegration(uint256 id) external view returns (IntegrationRecord memory) {
        return records[id];
    }
}
