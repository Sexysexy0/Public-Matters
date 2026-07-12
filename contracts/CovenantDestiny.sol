// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Destiny
/// @notice Long-term trajectory and collective telos contract
contract CovenantDestiny {
    address public guardian;
    uint256 public destinyCount;

    struct Destiny {
        uint256 id;
        string goal;
        string pathway;
        uint256 horizonYear;
        bool active;
    }

    mapping(uint256 => Destiny) public destinies;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event DestinyDeclared(uint256 indexed id, string goal, uint256 horizonYear);
    event DestinyUpdated(uint256 indexed id, string goal, string pathway);
    event DestinyStatusChanged(uint256 indexed id, bool active);

    constructor() {
        guardian = msg.sender;
        destinyCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑declare ng bagong destiny trajectory
    function declareDestiny(string calldata goal, string calldata pathway, uint256 horizonYear) external onlyGuardian {
        destinyCount++;
        destinies[destinyCount] = Destiny(destinyCount, goal, pathway, horizonYear, true);
        emit DestinyDeclared(destinyCount, goal, horizonYear);
    }

    /// @notice Mag‑update ng existing destiny
    function updateDestiny(uint256 id, string calldata goal, string calldata pathway) external onlyGuardian {
        Destiny storage d = destinies[id];
        d.goal = goal;
        d.pathway = pathway;
        emit DestinyUpdated(id, goal, pathway);
    }

    /// @notice Baguhin ang status ng destiny (active/inactive)
    function setDestinyStatus(uint256 id, bool active) external onlyGuardian {
        destinies[id].active = active;
        emit DestinyStatusChanged(id, active);
    }

    /// @notice Tingnan ang destiny details
    function viewDestiny(uint256 id) external view returns (Destiny memory) {
        return destinies[id];
    }
}
