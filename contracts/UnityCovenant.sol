// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Unity Covenant
/// @notice Binding contract that links all covenants together
contract UnityCovenant {
    address public guardian;

    address public justiceCovenant;
    address public integrityCovenant;
    address public computationalCovenant;
    address public rightsLedger;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CovenantLinked(string covenantName, address covenantAddress);

    constructor(
        address _justice,
        address _integrity,
        address _computational,
        address _rightsLedger
    ) {
        guardian = msg.sender;
        justiceCovenant = _justice;
        integrityCovenant = _integrity;
        computationalCovenant = _computational;
        rightsLedger = _rightsLedger;
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

    /// @notice I‑link ang covenant contracts
    function linkCovenant(string calldata name, address covenant) external onlyGuardian {
        require(covenant != address(0), "Invalid covenant address");

        if (keccak256(bytes(name)) == keccak256("Justice")) {
            justiceCovenant = covenant;
        } else if (keccak256(bytes(name)) == keccak256("Integrity")) {
            integrityCovenant = covenant;
        } else if (keccak256(bytes(name)) == keccak256("Computational")) {
            computationalCovenant = covenant;
        } else if (keccak256(bytes(name)) == keccak256("RightsLedger")) {
            rightsLedger = covenant;
        }

        emit CovenantLinked(name, covenant);
    }

    /// @notice Tingnan ang covenant address
    function viewCovenant(string calldata name) external view returns (address) {
        if (keccak256(bytes(name)) == keccak256("Justice")) {
            return justiceCovenant;
        } else if (keccak256(bytes(name)) == keccak256("Integrity")) {
            return integrityCovenant;
        } else if (keccak256(bytes(name)) == keccak256("Computational")) {
            return computationalCovenant;
        } else if (keccak256(bytes(name)) == keccak256("RightsLedger")) {
            return rightsLedger;
        }
        return address(0);
    }
}
