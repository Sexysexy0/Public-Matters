// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TemporalArchitectCodex
/// @notice Codex covenant to encode Tenet theory of Protagonist as architect
contract TemporalArchitectCodex {
    address public overseer;
    uint256 public doctrineCount;

    struct DoctrineRecord {
        uint256 id;
        string doctrine;    // parasitic logistics, ignorance doctrine, determinism, tragic fate
        string safeguard;   // accountability clause, governance clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => DoctrineRecord) public records;

    event DoctrineLogged(uint256 indexed id, string doctrine, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs doctrine record
    function logDoctrine(string calldata doctrine, string calldata safeguard, string calldata notes) external onlyOverseer {
        doctrineCount++;
        records[doctrineCount] = DoctrineRecord({
            id: doctrineCount,
            doctrine: doctrine,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit DoctrineLogged(doctrineCount, doctrine, safeguard);
    }

    /// @notice Citizens can view doctrine records
    function viewDoctrine(uint256 id) external view returns (DoctrineRecord memory) {
        return records[id];
    }
}
