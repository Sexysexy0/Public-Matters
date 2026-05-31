// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PromptInjectionDefense
/// @notice Safeguard contract to detect and block malicious prompt injections
/// @dev Encodes governance rules for AI workflows

contract PromptInjectionDefense {
    address public guardian;
    mapping(uint256 => string) public flaggedPrompts;
    uint256 public flaggedCount;

    event PromptFlagged(uint256 id, string reason, uint256 timestamp);
    event PromptCleared(uint256 id, uint256 timestamp);
    event DefenseAudit(address indexed auditor, string report, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
        flaggedCount = 0;
    }

    /// @notice Flag a prompt as malicious
    /// @param reason short descriptor (e.g., "Phishing link injection")
    function flagPrompt(string calldata reason) external onlyGuardian {
        flaggedCount++;
        flaggedPrompts[flaggedCount] = reason;
        emit PromptFlagged(flaggedCount, reason, block.timestamp);
    }

    /// @notice Clear a flagged prompt after review
    /// @param id identifier of the flagged prompt
    function clearPrompt(uint256 id) external onlyGuardian {
        require(bytes(flaggedPrompts[id]).length > 0, "Prompt not found");
        delete flaggedPrompts[id];
        emit PromptCleared(id, block.timestamp);
    }

    /// @notice Log an audit report for defense activity
    /// @param report narrative of audit findings
    function logAudit(string calldata report) external onlyGuardian {
        emit DefenseAudit(msg.sender, report, block.timestamp);
    }

    /// @notice Check if a prompt is flagged
    /// @param id identifier of the prompt
    /// @return true if flagged
    function isFlagged(uint256 id) external view returns (bool) {
        return bytes(flaggedPrompts[id]).length > 0;
    }
}
