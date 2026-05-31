// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MachiavelliMisconceptionDefense
/// @notice Safeguard contract to log and flag misconceptions about Machiavelli
/// @dev Encodes governance rules for studying Machiavelli faithfully

contract MachiavelliMisconceptionDefense {
    address public guardian;
    uint256 public flaggedCount;

    struct Misconception {
        uint256 id;
        string category;   // e.g., "Tyrant Myth", "Satire Claim", "AI Fake Quotes"
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Misconception) public flagged;
    event MisconceptionFlagged(uint256 id, string category, string details, uint256 timestamp);
    event MisconceptionCleared(uint256 id, uint256 timestamp);
    event StudyRecommendation(string source, string work, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
        flaggedCount = 0;
    }

    /// @notice Flag a misconception about Machiavelli
    function flagMisconception(string calldata category, string calldata details) external onlyGuardian {
        flaggedCount++;
        flagged[flaggedCount] = Misconception(flaggedCount, category, details, block.timestamp);
        emit MisconceptionFlagged(flaggedCount, category, details, block.timestamp);
    }

    /// @notice Clear a misconception after review
    function clearMisconception(uint256 id) external onlyGuardian {
        require(bytes(flagged[id].details).length > 0, "Misconception not found");
        delete flagged[id];
        emit MisconceptionCleared(id, block.timestamp);
    }

    /// @notice Log a study recommendation (primary or secondary sources)
    function recommendStudy(string calldata source, string calldata work) external onlyGuardian {
        emit StudyRecommendation(source, work, block.timestamp);
    }
}
