// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Infinity
/// @notice Boundless expansion and limitless horizon contract
contract CovenantInfinity {
    address public guardian;
    uint256 public infinityCount;

    struct Horizon {
        uint256 id;
        string vision;
        string expansionPath;
        bool limitless;
    }

    mapping(uint256 => Horizon) public horizons;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event HorizonDeclared(uint256 indexed id, string vision, bool limitless);

    constructor() {
        guardian = msg.sender;
        infinityCount = 0;
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

    /// @notice Mag‑declare ng infinity horizon
    function declareHorizon(string calldata vision, string calldata expansionPath, bool limitless) external onlyGuardian {
        infinityCount++;
        horizons[infinityCount] = Horizon(infinityCount, vision, expansionPath, limitless);
        emit HorizonDeclared(infinityCount, vision, limitless);
    }

    /// @notice Tingnan ang horizon details
    function viewHorizon(uint256 id) external view returns (Horizon memory) {
        return horizons[id];
    }
}
