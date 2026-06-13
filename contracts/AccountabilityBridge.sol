// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AccountabilityBridge
/// @notice Bridge covenant to connect citizen oversight with institutional safeguards
contract AccountabilityBridge {
    address public overseer;
    uint256 public bridgeCount;

    struct OversightRecord {
        uint256 id;
        string citizenInput;   // e.g. complaint, audit request, feedback
        string safeguard;      // transparency, fairness, integrity
        string institutionalResponse; // action taken by institution
        string notes;          // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => OversightRecord) public records;

    event OversightLinked(uint256 indexed id, string citizenInput, string safeguard, string institutionalResponse, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer links citizen oversight to institutional safeguard
    function linkOversight(string calldata citizenInput, string calldata safeguard, string calldata institutionalResponse, string calldata notes) external onlyOverseer {
        bridgeCount++;
        records[bridgeCount] = OversightRecord({
            id: bridgeCount,
            citizenInput: citizenInput,
            safeguard: safeguard,
            institutionalResponse: institutionalResponse,
            notes: notes,
            timestamp: block.timestamp
        });
        emit OversightLinked(bridgeCount, citizenInput, safeguard, institutionalResponse, notes);
    }

    /// @notice Citizens can view oversight records
    function viewOversight(uint256 id) external view returns (OversightRecord memory) {
        return records[id];
    }
}
