// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WaterGovernanceReversion
/// @notice Covenant contract to restore water management authority to Malolos Water District
/// @dev Encodes community safeguard vs exploitative private concession

contract WaterGovernanceReversion {
    address public guardian;
    bool public reverted;
    event AuthorityReverted(address indexed initiator, uint256 timestamp);
    event AttemptBlocked(address indexed actor, string reason, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
        reverted = false;
    }

    /// @notice Execute reversion of water management back to Malolos Water District
    function revertAuthority() external onlyGuardian {
        require(!reverted, "Already reverted");
        reverted = true;
        emit AuthorityReverted(msg.sender, block.timestamp);
    }

    /// @notice Block exploitative attempts (e.g., private concession abuse)
    /// @param actor address of entity attempting exploit
    /// @param reason short descriptor of abuse
    function blockAttempt(address actor, string calldata reason) external onlyGuardian {
        emit AttemptBlocked(actor, reason, block.timestamp);
    }

    /// @notice Check if authority has been reverted
    /// @return true if Malolos Water District restored
    function isReverted() external view returns (bool) {
        return reverted;
    }
}
