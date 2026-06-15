// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NarrativeFlowCodex
/// @notice Codex covenant to encode storytelling safeguards in board reporting
contract NarrativeFlowCodex {
    address public overseer;
    uint256 public narrativeCount;

    struct NarrativeRecord {
        uint256 id;
        string element;     // context, visualization, flow, interpretation
        string safeguard;   // clarity clause, accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => NarrativeRecord) public records;

    event NarrativeLogged(uint256 indexed id, string element, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs narrative element record
    function logNarrative(string calldata element, string calldata safeguard, string calldata notes) external onlyOverseer {
        narrativeCount++;
        records[narrativeCount] = NarrativeRecord({
            id: narrativeCount,
            element: element,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit NarrativeLogged(narrativeCount, element, safeguard);
    }

    /// @notice Citizens can view narrative element records
    function viewNarrative(uint256 id) external view returns (NarrativeRecord memory) {
        return records[id];
    }
}
