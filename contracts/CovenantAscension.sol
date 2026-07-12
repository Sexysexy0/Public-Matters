// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Ascension
/// @notice Transcendence and higher-order governance contract
contract CovenantAscension {
    address public guardian;
    uint256 public ascensionCount;

    struct Ascension {
        uint256 id;
        string covenantName;
        string transcendencePrinciple;
        bool elevated;
    }

    mapping(uint256 => Ascension) public ascensions;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event AscensionDeclared(uint256 indexed id, string covenantName, string principle, bool elevated);

    constructor() {
        guardian = msg.sender;
        ascensionCount = 0;
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

    /// @notice Mag‑declare ng ascension principle
    function declareAscension(string calldata covenantName, string calldata principle, bool elevated) external onlyGuardian {
        ascensionCount++;
        ascensions[ascensionCount] = Ascension(ascensionCount, covenantName, principle, elevated);
        emit AscensionDeclared(ascensionCount, covenantName, principle, elevated);
    }

    /// @notice Tingnan ang ascension details
    function viewAscension(uint256 id) external view returns (Ascension memory) {
        return ascensions[id];
    }
}
