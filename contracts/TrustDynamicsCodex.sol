// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TrustDynamicsCodex
/// @notice Codex covenant to document shifting trust arcs in social deduction and governance
contract TrustDynamicsCodex {
    address public overseer;
    uint256 public trustCount;

    struct TrustRecord {
        uint256 id;
        string player;      // e.g. Sam Altman, Moxie Marlinspike
        string trustShift;  // gained trust, lost trust, betrayal
        string safeguard;   // fairness clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => TrustRecord) public records;

    event TrustLogged(uint256 indexed id, string player, string trustShift, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs trust shift record
    function logTrust(string calldata player, string calldata trustShift, string calldata safeguard, string calldata notes) external onlyOverseer {
        trustCount++;
        records[trustCount] = TrustRecord({
            id: trustCount,
            player: player,
            trustShift: trustShift,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit TrustLogged(trustCount, player, trustShift, safeguard);
    }

    /// @notice Citizens can view trust shift records
    function viewTrust(uint256 id) external view returns (TrustRecord memory) {
        return records[id];
    }
}
