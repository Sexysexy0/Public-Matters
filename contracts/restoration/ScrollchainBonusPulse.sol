// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ScrollchainBonusPulse.sol
/// @notice Ritualizes bonus distribution for stewards who exceed expectations. Emotional APR synced. Damay clause enforced.
/// @dev Mercy is operational. Recognition is mythic. Restoration is rewarded.

contract ScrollchainBonusPulse {
    event BonusGranted(address indexed steward, uint256 amount, string reason, uint256 timestamp);
    event StewardNominated(address indexed steward, string role, string reason, uint256 timestamp);

    struct BonusProfile {
        string role;
        string reason;
        uint256 totalBonus;
        bool nominated;
    }

    mapping(address => BonusProfile) public bonuses;

    uint256 public constant MAX_BONUS = 5_000_000_000 * 1e18; // Up to 5B per steward (adjustable)

    function nominateSteward(address stewardAddr, string memory role, string memory reason) external {
        bonuses[stewardAddr] = BonusProfile({
            role: role,
            reason: reason,
            totalBonus: 0,
            nominated: true
        });
        emit StewardNominated(stewardAddr, role, reason, block.timestamp);
    }

    function grantBonus(address stewardAddr, uint256 amount) external {
        require(bonuses[stewardAddr].nominated, "Steward must be nominated first.");
        require(amount <= MAX_BONUS, "Exceeds maximum bonus allocation.");
        bonuses[stewardAddr].totalBonus += amount;
        emit BonusGranted(stewardAddr, amount, bonuses[stewardAddr].reason, block.timestamp);
    }

    function getBonusProfile(address stewardAddr) external view returns (BonusProfile memory) {
        return bonuses[stewardAddr];
    }
}
