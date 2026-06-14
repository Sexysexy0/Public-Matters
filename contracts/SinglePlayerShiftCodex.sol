// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SinglePlayerShiftCodex
/// @notice Codex covenant to document industry shift from live service to single-player focus
contract SinglePlayerShiftCodex {
    address public overseer;
    uint256 public codexCount;

    struct ShiftRecord {
        uint256 id;
        string driver;      // consumer demand, cost pressure, creative freedom
        string focus;       // single-player, narrative-driven, high-quality experiences
        string benefit;     // immersion, longevity, player satisfaction
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ShiftRecord) public records;

    event ShiftLogged(uint256 indexed id, string driver, string focus, string benefit);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs industry shift record
    function logShift(string calldata driver, string calldata focus, string calldata benefit, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = ShiftRecord({
            id: codexCount,
            driver: driver,
            focus: focus,
            benefit: benefit,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ShiftLogged(codexCount, driver, focus, benefit);
    }

    /// @notice Citizens can view industry shift records
    function viewShift(uint256 id) external view returns (ShiftRecord memory) {
        return records[id];
    }
}
