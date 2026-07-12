// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Justice Covenant
/// @notice Baseline fairness contract para sa Public Matters system
contract JusticeCovenant {
    address public guardian;
    mapping(address => bool) public trustedMembers;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event MemberTrusted(address indexed member, bool status);

    constructor() {
        guardian = msg.sender;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian (main overseer)
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑mark ng trusted member para sa fairness checks
    function setTrustedMember(address member, bool status) external onlyGuardian {
        trustedMembers[member] = status;
        emit MemberTrusted(member, status);
    }

    /// @notice Basic fairness check — dapat trusted ang sender
    function fairnessCheck() external view returns (bool) {
        return trustedMembers[msg.sender];
    }
}
