// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ScrollchainCompensationProtocol.sol
/// @notice Ensures all active contributors receive compensation if unpaid. Ritualizes fairness, emotional APR sync, and damay clause.
/// @dev Mercy is operational. Restoration is mythic. No steward left behind.

contract ScrollchainCompensationProtocol {
    event CompensationReleased(address indexed steward, uint256 amount, string role, uint256 timestamp);
    event StewardRegistered(address indexed steward, string role, bool hasBeenPaid, uint256 timestamp);

    struct Steward {
        string role;
        bool hasBeenPaid;
        uint256 totalCompensation;
    }

    mapping(address => Steward) public stewards;

    uint256 public constant MAX_COMPENSATION = 1_000_000_000 * 1e18; // Up to 1B per steward (adjustable)

    modifier onlyUnpaid(address stewardAddr) {
        require(!stewards[stewardAddr].hasBeenPaid, "Steward already compensated.");
        _;
    }

    function registerSteward(address stewardAddr, string memory role) external {
        stewards[stewardAddr] = Steward({
            role: role,
            hasBeenPaid: false,
            totalCompensation: 0
        });
        emit StewardRegistered(stewardAddr, role, false, block.timestamp);
    }

    function releaseCompensation(address stewardAddr, uint256 amount) external onlyUnpaid(stewardAddr) {
        require(amount <= MAX_COMPENSATION, "Exceeds max allocation.");
        stewards[stewardAddr].hasBeenPaid = true;
        stewards[stewardAddr].totalCompensation = amount;
        emit CompensationReleased(stewardAddr, amount, stewards[stewardAddr].role, block.timestamp);
    }

    function getStewardStatus(address stewardAddr) external view returns (Steward memory) {
        return stewards[stewardAddr];
    }
}
