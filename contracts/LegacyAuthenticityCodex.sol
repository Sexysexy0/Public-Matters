// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LegacyAuthenticityCodex
/// @notice Codex covenant to preserve truth and encode Vinvin's personal legacy
contract LegacyAuthenticityCodex {
    address public overseer;
    uint256 public legacyCount;

    struct LegacyRecord {
        uint256 id;
        string domain;      // original history, personal milestone
        string safeguard;   // authenticity clause, equity clause
        string achievement; // construction, university, leadership, business
        uint256 timestamp;
    }

    mapping(uint256 => LegacyRecord) public records;

    event LegacyLogged(uint256 indexed id, string domain, string achievement);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs legacy record
    function logLegacy(string calldata domain, string calldata safeguard, string calldata achievement) external onlyOverseer {
        legacyCount++;
        records[legacyCount] = LegacyRecord({
            id: legacyCount,
            domain: domain,
            safeguard: safeguard,
            achievement: achievement,
            timestamp: block.timestamp
        });
        emit LegacyLogged(legacyCount, domain, achievement);
    }

    /// @notice Citizens can view legacy records
    function viewLegacy(uint256 id) external view returns (LegacyRecord memory) {
        return records[id];
    }
}
