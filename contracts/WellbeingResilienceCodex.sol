// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WellbeingResilienceCodex
/// @notice Covenant encoding safeguards for mental health, humane workload, and rest cycles
contract WellbeingResilienceCodex {
    address public overseer;
    uint256 public recordCount;

    struct WellRecord {
        uint256 id;
        string domain;      // mental health, rest, workload, burnout, balance
        string safeguard;   // resilience clause, dignity clause, integrity clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => WellRecord) public records;

    event WellLogged(uint256 indexed id, string domain, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWell(string calldata domain, string calldata safeguard, string calldata notes) external onlyOverseer {
        recordCount++;
        records[recordCount] = WellRecord({
            id: recordCount,
            domain: domain,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit WellLogged(recordCount, domain, safeguard);
    }

    function viewWell(uint256 id) external view returns (WellRecord memory) {
        return records[id];
    }
}
