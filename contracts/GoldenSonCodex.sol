// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GoldenSonCodex
/// @notice Codex covenant to encode decorated CIA career origins of John Kiriakou
contract GoldenSonCodex {
    address public overseer;
    uint256 public codexCount;

    struct CareerRecord {
        uint256 id;
        string mission;     // Athens service, Abu Zubaydah capture
        string achievement; // decorated officer, pivotal role
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CareerRecord) public records;

    event CareerLogged(uint256 indexed id, string mission, string achievement);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs decorated career record
    function logCareer(string calldata mission, string calldata achievement, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = CareerRecord({
            id: codexCount,
            mission: mission,
            achievement: achievement,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CareerLogged(codexCount, mission, achievement);
    }

    /// @notice Citizens can view career records
    function viewCareer(uint256 id) external view returns (CareerRecord memory) {
        return records[id];
    }
}
