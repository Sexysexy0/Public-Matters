// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Renewal
/// @notice Refresh and regeneration contract for covenant governance system
contract CovenantRenewal {
    address public guardian;
    uint256 public renewalCount;

    struct Renewal {
        uint256 id;
        string covenantName;
        string reason;
        string newVersion;
        bool executed;
    }

    mapping(uint256 => Renewal) public renewals;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RenewalProposed(uint256 indexed id, string covenantName, string reason);
    event RenewalExecuted(uint256 indexed id, string newVersion);

    constructor() {
        guardian = msg.sender;
        renewalCount = 0;
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

    /// @notice Mag‑propose ng renewal para sa covenant
    function proposeRenewal(string calldata covenantName, string calldata reason) external onlyGuardian {
        renewalCount++;
        renewals[renewalCount] = Renewal(renewalCount, covenantName, reason, "", false);
        emit RenewalProposed(renewalCount, covenantName, reason);
    }

    /// @notice Mag‑execute ng renewal at mag‑assign ng bagong version
    function executeRenewal(uint256 id, string calldata newVersion) external onlyGuardian {
        Renewal storage r = renewals[id];
        require(!r.executed, "Already executed");
        r.newVersion = newVersion;
        r.executed = true;
        emit RenewalExecuted(id, newVersion);
    }

    /// @notice Tingnan ang renewal details
    function viewRenewal(uint256 id) external view returns (Renewal memory) {
        return renewals[id];
    }
}
