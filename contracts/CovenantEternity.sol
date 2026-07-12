// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Eternity
/// @notice Perpetual legacy and timeless safeguard contract
contract CovenantEternity {
    address public guardian;
    uint256 public principleCount;

    struct Principle {
        uint256 id;
        string title;
        string description;
        bool eternal;
    }

    mapping(uint256 => Principle) public principles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event PrincipleDeclared(uint256 indexed id, string title, bool eternal);

    constructor() {
        guardian = msg.sender;
        principleCount = 0;
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

    /// @notice Mag‑declare ng eternal principle
    function declarePrinciple(string calldata title, string calldata description, bool eternal) external onlyGuardian {
        principleCount++;
        principles[principleCount] = Principle(principleCount, title, description, eternal);
        emit PrincipleDeclared(principleCount, title, eternal);
    }

    /// @notice Tingnan ang principle details
    function viewPrinciple(uint256 id) external view returns (Principle memory) {
        return principles[id];
    }
}
