// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CitizenVoiceLedger
/// @notice Ledger covenant to record citizen feedback and oversight inputs on-chain
contract CitizenVoiceLedger {
    address public overseer;
    uint256 public entryCount;

    struct VoiceEntry {
        uint256 id;
        string citizenInput;   // e.g. feedback, complaint, audit request
        string safeguard;      // transparency, fairness, accountability
        string notes;          // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => VoiceEntry) public entries;

    event VoiceLogged(uint256 indexed id, string citizenInput, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs citizen voice entry
    function logVoice(string calldata citizenInput, string calldata safeguard, string calldata notes) external onlyOverseer {
        entryCount++;
        entries[entryCount] = VoiceEntry({
            id: entryCount,
            citizenInput: citizenInput,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit VoiceLogged(entryCount, citizenInput, safeguard, notes);
    }

    /// @notice Citizens can view voice entries
    function viewVoice(uint256 id) external view returns (VoiceEntry memory) {
        return entries[id];
    }
}
