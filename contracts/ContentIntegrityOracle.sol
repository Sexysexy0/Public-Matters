// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ContentIntegrityOracle
/// @notice Oracle safeguard vs AI spam, parasite SEO, and zero-click traps
/// @dev Feeds integrity signals to DAO governance for voting + execution

contract ContentIntegrityOracle {
    address public guardian;
    mapping(bytes32 => bool) public flaggedContent;
    event ContentFlagged(bytes32 indexed contentHash, string reason, uint256 timestamp);
    event ContentCleared(bytes32 indexed contentHash, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
    }

    /// @notice Flag suspicious content (AI spam, parasite SEO, zero-click trap)
    /// @param contentHash keccak256 hash of the content
    /// @param reason short descriptor of why flagged
    function flagContent(bytes32 contentHash, string calldata reason) external onlyGuardian {
        flaggedContent[contentHash] = true;
        emit ContentFlagged(contentHash, reason, block.timestamp);
    }

    /// @notice Clear flagged content after DAO review
    /// @param contentHash keccak256 hash of the content
    function clearContent(bytes32 contentHash) external onlyGuardian {
        flaggedContent[contentHash] = false;
        emit ContentCleared(contentHash, block.timestamp);
    }

    /// @notice Check if content is flagged
    /// @param contentHash keccak256 hash of the content
    /// @return true if flagged
    function isFlagged(bytes32 contentHash) external view returns (bool) {
        return flaggedContent[contentHash];
    }
}
