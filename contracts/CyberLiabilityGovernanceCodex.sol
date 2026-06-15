// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CyberLiabilityGovernanceCodex
/// @notice Codex covenant to encode board liability safeguards in cybersecurity failures
contract CyberLiabilityGovernanceCodex {
    address public overseer;
    uint256 public liabilityCount;

    struct LiabilityRecord {
        uint256 id;
        string framework;   // Cybercrimes Act, NDPA, CBN Framework, CAMA, etc.
        string duty;        // fiduciary duty, oversight, compliance
        string safeguard;   // accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => LiabilityRecord) public records;

    event LiabilityLogged(uint256 indexed id, string framework, string duty, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs liability safeguard record
    function logLiability(string calldata framework, string calldata duty, string calldata safeguard, string calldata notes) external onlyOverseer {
        liabilityCount++;
        records[liabilityCount] = LiabilityRecord({
            id: liabilityCount,
            framework: framework,
            duty: duty,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit LiabilityLogged(liabilityCount, framework, duty, safeguard);
    }

    /// @notice Citizens can view liability safeguard records
    function viewLiability(uint256 id) external view returns (LiabilityRecord memory) {
        return records[id];
    }
}
