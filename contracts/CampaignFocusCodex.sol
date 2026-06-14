// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CampaignFocusCodex
/// @notice Codex covenant to encode marketing focus promises and enforce campaign/DMZ priority
contract CampaignFocusCodex {
    address public overseer;
    uint256 public focusCount;

    struct FocusRecord {
        uint256 id;
        string mode;        // campaign, DMZ, Warzone
        string pledge;      // what developers promised
        string safeguard;   // accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => FocusRecord) public records;

    event FocusLogged(uint256 indexed id, string mode, string pledge, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs marketing focus record
    function logFocus(string calldata mode, string calldata pledge, string calldata safeguard, string calldata notes) external onlyOverseer {
        focusCount++;
        records[focusCount] = FocusRecord({
            id: focusCount,
            mode: mode,
            pledge: pledge,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit FocusLogged(focusCount, mode, pledge, safeguard);
    }

    /// @notice Citizens can view marketing focus records
    function viewFocus(uint256 id) external view returns (FocusRecord memory) {
        return records[id];
    }
}
