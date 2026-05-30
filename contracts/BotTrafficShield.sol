// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BotTrafficShield
/// @notice DAO-controlled safeguard vs suspicious bot traffic
/// @dev Complements ContentIntegrityOracle + HumanSignalRegistry

contract BotTrafficShield {
    address public guardian;
    mapping(address => bool) public flaggedBots;
    event BotFlagged(address indexed bot, string reason, uint256 timestamp);
    event BotCleared(address indexed bot, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
    }

    /// @notice Flag suspicious bot address
    /// @param bot address of suspected bot
    /// @param reason short descriptor of why flagged
    function flagBot(address bot, string calldata reason) external onlyGuardian {
        flaggedBots[bot] = true;
        emit BotFlagged(bot, reason, block.timestamp);
    }

    /// @notice Clear flagged bot after DAO review
    /// @param bot address of suspected bot
    function clearBot(address bot) external onlyGuardian {
        flaggedBots[bot] = false;
        emit BotCleared(bot, block.timestamp);
    }

    /// @notice Check if bot is flagged
    /// @param bot address of suspected bot
    /// @return true if flagged
    function isFlagged(address bot) external view returns (bool) {
        return flaggedBots[bot];
    }
}
