// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GranularSealCodex
/// @notice Codex covenant to seal detailed entries of Vinvin's personal legacy
contract GranularSealCodex {
    address public overseer;
    uint256 public sealCount;

    struct SealEntry {
        uint256 id;
        string domain;      // construction, university, leadership, business
        string seal;        // authenticity seal, authorship seal
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => SealEntry) public records;

    event SealLogged(uint256 indexed id, string domain, string seal);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs detailed seal entry
    function logSeal(string calldata domain, string calldata seal, string calldata notes) external onlyOverseer {
        sealCount++;
        records[sealCount] = SealEntry({
            id: sealCount,
            domain: domain,
            seal: seal,
            notes: notes,
            timestamp: block.timestamp
        });
        emit SealLogged(sealCount, domain, seal);
    }

    /// @notice Citizens can view detailed seal entries
    function viewSeal(uint256 id) external view returns (SealEntry memory) {
        return records[id];
    }
}
