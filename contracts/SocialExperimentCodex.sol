// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SocialExperimentCodex
/// @notice Codex covenant to document long-term effects of social experiments
contract SocialExperimentCodex {
    address public overseer;
    uint256 public codexCount;

    struct ExperimentRecord {
        uint256 id;
        string experiment;   // e.g. sex education, judicial reform, welfare policy
        string effect;       // positive, negative, mixed
        string safeguard;    // resilience, accountability, clarity
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ExperimentRecord) public records;

    event ExperimentLogged(uint256 indexed id, string experiment, string effect, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs social experiment effect
    function logExperiment(string calldata experiment, string calldata effect, string calldata safeguard, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = ExperimentRecord({
            id: codexCount,
            experiment: experiment,
            effect: effect,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ExperimentLogged(codexCount, experiment, effect, safeguard, notes);
    }

    /// @notice Citizens can view experiment records
    function viewExperiment(uint256 id) external view returns (ExperimentRecord memory) {
        return records[id];
    }
}
