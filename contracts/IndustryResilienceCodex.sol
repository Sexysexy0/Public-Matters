// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IndustryResilienceCodex
/// @notice Codex covenant to document video game industry crisis and resilience strategies
contract IndustryResilienceCodex {
    address public overseer;
    uint256 public codexCount;

    struct CrisisRecord {
        uint256 id;
        string theme;       // Xbox layoffs, Rising costs, Corporate bloat
        string detail;      // description of issue
        string notes;       // contextual application
        uint256 timestamp;
    }

    struct ResilienceRecord {
        uint256 id;
        string strategy;    // single-player focus, optimization wars, consumer advantage
        string benefit;     // why it helps industry/players
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CrisisRecord) public crisisRecords;
    mapping(uint256 => ResilienceRecord) public resilienceRecords;

    uint256 public crisisCount;
    uint256 public resilienceCount;

    event CrisisLogged(uint256 indexed id, string theme, string detail);
    event ResilienceLogged(uint256 indexed id, string strategy, string benefit);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs industry crisis record
    function logCrisis(string calldata theme, string calldata detail, string calldata notes) external onlyOverseer {
        crisisCount++;
        crisisRecords[crisisCount] = CrisisRecord({
            id: crisisCount,
            theme: theme,
            detail: detail,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CrisisLogged(crisisCount, theme, detail);
    }

    /// @notice Overseer logs resilience strategy record
    function logResilience(string calldata strategy, string calldata benefit, string calldata notes) external onlyOverseer {
        resilienceCount++;
        resilienceRecords[resilienceCount] = ResilienceRecord({
            id: resilienceCount,
            strategy: strategy,
            benefit: benefit,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ResilienceLogged(resilienceCount, strategy, benefit);
    }

    /// @notice Citizens can view crisis records
    function viewCrisis(uint256 id) external view returns (CrisisRecord memory) {
        return crisisRecords[id];
    }

    /// @notice Citizens can view resilience records
    function viewResilience(uint256 id) external view returns (ResilienceRecord memory) {
        return resilienceRecords[id];
    }
}
