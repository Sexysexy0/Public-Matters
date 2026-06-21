// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TwinPrimeCodex
/// @notice Covenant to encode milestones of the Twin Prime Conjecture
contract TwinPrimeCodex {
    address public overseer;
    uint256 public recordCount;

    struct PrimeRecord {
        uint256 id;
        string domain;      // twin primes, sieve, breakthrough, refinement, future
        string safeguard;   // truth clause, rigor clause, collaboration clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => PrimeRecord) public records;

    event PrimeLogged(uint256 indexed id, string domain, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPrime(string calldata domain, string calldata safeguard, string calldata notes) external onlyOverseer {
        recordCount++;
        records[recordCount] = PrimeRecord({
            id: recordCount,
            domain: domain,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PrimeLogged(recordCount, domain, safeguard);
    }

    function viewPrime(uint256 id) external view returns (PrimeRecord memory) {
        return records[id];
    }
}
