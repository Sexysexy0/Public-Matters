// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyCodex
/// @notice Covenant contract to encode openness, auditability, and governance traceability
/// @dev Provides structured rituals for transparent governance records
contract TransparencyCodex {
    address public overseer;
    uint256 public covenantCount;

    struct Record {
        uint256 id;
        string action;          // Governance action description
        string actor;           // Actor responsible (e.g., overseer, citizen, provider)
        bool auditable;         // True if record is auditable
        bool traceable;         // True if record is traceable
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => Record) public records;

    event RecordLogged(
        uint256 indexed id,
        string action,
        string actor,
        bool auditable,
        bool traceable,
        string notes
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs governance record with transparency safeguards
    function logRecord(
        string calldata action,
        string calldata actor,
        bool auditable,
        bool traceable,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        records[covenantCount] = Record({
            id: covenantCount,
            action: action,
            actor: actor,
            auditable: auditable,
            traceable: traceable,
            notes: notes,
            timestamp: block.timestamp
        });
        emit RecordLogged(covenantCount, action, actor, auditable, traceable, notes);
    }

    /// @notice Governance rule: if auditable == false or traceable == false, mark as opaque
    function isOpaque(uint256 id) external view returns (bool) {
        Record memory r = records[id];
        return (!r.auditable || !r.traceable);
    }
}
