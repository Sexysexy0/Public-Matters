// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityDigest
/// @notice Covenant to compile player feedback into structured records
contract CommunityDigest {
    address public overseer;
    uint256 public digestCount;

    struct FeedbackDigest {
        uint256 id;
        string theme;       // OP freeze, vehicle counter, stacking, skins
        string playerQuote; // short excerpt from comment
        string suggestion;  // proposed adjustment or idea
        string mode;        // Operations, Warfare, Vehicles, Cosmetics
        uint256 timestamp;
    }

    mapping(uint256 => FeedbackDigest) public records;

    event DigestLogged(uint256 indexed id, string theme, string playerQuote, string suggestion, string mode);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs compiled feedback digest
    function logDigest(string calldata theme, string calldata playerQuote, string calldata suggestion, string calldata mode) external onlyOverseer {
        digestCount++;
        records[digestCount] = FeedbackDigest({
            id: digestCount,
            theme: theme,
            playerQuote: playerQuote,
            suggestion: suggestion,
            mode: mode,
            timestamp: block.timestamp
        });
        emit DigestLogged(digestCount, theme, playerQuote, suggestion, mode);
    }

    /// @notice Citizens can view compiled feedback digests
    function viewDigest(uint256 id) external view returns (FeedbackDigest memory) {
        return records[id];
    }
}
