// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Redemption
/// @notice Restorative and renewal safeguard contract
contract CovenantRedemption {
    address public guardian;
    uint256 public redemptionCount;

    struct Restoration {
        uint256 id;
        string subject;
        string healingPrinciple;
        string renewalPath;
        bool completed;
    }

    mapping(uint256 => Restoration) public restorations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RedemptionDeclared(uint256 indexed id, string subject, string healingPrinciple);
    event RedemptionCompleted(uint256 indexed id, string renewalPath);

    constructor() {
        guardian = msg.sender;
        redemptionCount = 0;
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

    /// @notice Mag‑declare ng redemption principle
    function declareRedemption(string calldata subject, string calldata healingPrinciple) external onlyGuardian {
        redemptionCount++;
        restorations[redemptionCount] = Restoration(redemptionCount, subject, healingPrinciple, "", false);
        emit RedemptionDeclared(redemptionCount, subject, healingPrinciple);
    }

    /// @notice Mag‑complete ng redemption at mag‑assign ng renewal path
    function completeRedemption(uint256 id, string calldata renewalPath) external onlyGuardian {
        Restoration storage r = restorations[id];
        require(!r.completed, "Already completed");
        r.renewalPath = renewalPath;
        r.completed = true;
        emit RedemptionCompleted(id, renewalPath);
    }

    /// @notice Tingnan ang redemption details
    function viewRedemption(uint256 id) external view returns (Restoration memory) {
        return restorations[id];
    }
}
