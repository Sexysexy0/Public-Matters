// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WorkResilienceCodex
/// @notice Covenant encoding safeguards for realistic targets, burnout prevention, and meaningful work
contract WorkResilienceCodex {
    address public overseer;
    uint256 public recordCount;

    struct WorkRecord {
        uint256 id;
        string domain;      // targets, meaning, burnout, alignment, feedback
        string safeguard;   // integrity clause, dignity clause, resilience clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => WorkRecord) public records;

    event WorkLogged(uint256 indexed id, string domain, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWork(string calldata domain, string calldata safeguard, string calldata notes) external onlyOverseer {
        recordCount++;
        records[recordCount] = WorkRecord({
            id: recordCount,
            domain: domain,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit WorkLogged(recordCount, domain, safeguard);
    }

    function viewWork(uint256 id) external view returns (WorkRecord memory) {
        return records[id];
    }
}
