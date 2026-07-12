// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Registry
/// @notice Master index of all covenant contracts in the Public Matters system
contract CovenantRegistry {
    address public guardian;
    mapping(string => address) private covenantIndex;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CovenantRegistered(string covenantName, address covenantAddress);

    constructor() {
        guardian = msg.sender;
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

    /// @notice Mag‑register ng covenant contract sa registry
    function registerCovenant(string calldata name, address covenant) external onlyGuardian {
        require(covenant != address(0), "Invalid covenant address");
        covenantIndex[name] = covenant;
        emit CovenantRegistered(name, covenant);
    }

    /// @notice Tingnan ang covenant address by name
    function viewCovenant(string calldata name) external view returns (address) {
        return covenantIndex[name];
    }
}
