// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SystemIntegrityChain
/// @notice Chain covenant for continuous monitoring of system core integrity
contract SystemIntegrityChain {
    address public oversightCommittee;
    uint256 public chainCount;

    struct IntegrityRecord {
        uint256 id;
        string domain;     // e.g. tech, creative, governance
        string status;     // clean, drift, corrupted
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => IntegrityRecord) public records;

    event IntegrityLogged(uint256 indexed id, string domain, string status, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs integrity status for a domain
    function logIntegrity(string calldata domain, string calldata status, string calldata notes) external onlyOversight {
        chainCount++;
        records[chainCount] = IntegrityRecord({
            id: chainCount,
            domain: domain,
            status: status,
            notes: notes,
            timestamp: block.timestamp
        });
        emit IntegrityLogged(chainCount, domain, status, notes);
    }

    /// @notice Citizens can view integrity records
    function viewIntegrity(uint256 id) external view returns (IntegrityRecord memory) {
        return records[id];
    }
}
