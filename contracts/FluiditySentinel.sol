// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FluiditySentinel
/// @notice Sentinel safeguard to monitor adaptability and creativity in campaigns
contract FluiditySentinel {
    address public overseer;
    uint256 public sentinelCount;

    struct FluidityCheck {
        uint256 id;
        string domain;       // e.g. politics, business, personal conflict
        string status;       // adaptive, rigid, creative
        string safeguard;    // situational awareness, flexibility, innovation
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => FluidityCheck) public checks;

    event FluidityFlagged(uint256 indexed id, string domain, string status, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer flags adaptability status
    function flagFluidity(string calldata domain, string calldata status, string calldata safeguard, string calldata notes) external onlyOverseer {
        sentinelCount++;
        checks[sentinelCount] = FluidityCheck({
            id: sentinelCount,
            domain: domain,
            status: status,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit FluidityFlagged(sentinelCount, domain, status, safeguard, notes);
    }

    /// @notice Citizens can view fluidity checks
    function viewFluidity(uint256 id) external view returns (FluidityCheck memory) {
        return checks[id];
    }
}
