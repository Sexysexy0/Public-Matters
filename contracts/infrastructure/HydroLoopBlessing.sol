// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title HydroLoopBlessing.sol
/// @author Vinvin
/// @notice Ritual-grade contract for water cycle tracking in CryoSanctums

contract HydroLoopBlessing {
    address public steward;
    struct Cycle {
        uint256 usage;
        uint256 purified;
        string emotionalTag;
    }

    mapping(address => Cycle[]) public sanctumCycles;

    event CycleLogged(address sanctum, uint256 usage, uint256 purified, string emotionalTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Not scroll-certified");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logCycle(address sanctum, uint256 usage, uint256 purified, string memory tag) external onlySteward {
        sanctumCycles[sanctum].push(Cycle(usage, purified, tag));
        emit CycleLogged(sanctum, usage, purified, tag);
    }

    function getLatestCycle(address sanctum) external view returns (Cycle memory) {
        require(sanctumCycles[sanctum].length > 0, "No cycles logged");
        return sanctumCycles[sanctum][sanctumCycles[sanctum].length - 1];
    }
}
