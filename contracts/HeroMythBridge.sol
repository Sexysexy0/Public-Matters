// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HeroMythBridge
/// @notice Bridge covenant to encode mythic resilience cycle through hero archetype
contract HeroMythBridge {
    address public overseer;
    uint256 public bridgeCount;

    struct HeroCycle {
        uint256 id;
        string stage;       // call to adventure, voluntary hardship, descent, transformation
        string lesson;      // resilience, meaning, courage, gratitude
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => HeroCycle) public records;

    event HeroLogged(uint256 indexed id, string stage, string lesson);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs hero myth cycle record
    function logHero(string calldata stage, string calldata lesson, string calldata notes) external onlyOverseer {
        bridgeCount++;
        records[bridgeCount] = HeroCycle({
            id: bridgeCount,
            stage: stage,
            lesson: lesson,
            notes: notes,
            timestamp: block.timestamp
        });
        emit HeroLogged(bridgeCount, stage, lesson);
    }

    /// @notice Citizens can view hero myth cycle records
    function viewHero(uint256 id) external view returns (HeroCycle memory) {
        return records[id];
    }
}
