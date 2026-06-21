// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IdentityEquityCodex
/// @notice Codex covenant to encode Vinvin's personal history and authorship safeguards
contract IdentityEquityCodex {
    address public overseer;
    uint256 public recordCount;

    struct IdentityRecord {
        uint256 id;
        string nickname;   // Unknown, No Name, Unlocked Character
        string milestone;  // industry, university, leadership achievement
        string safeguard;  // authorship clause, equity clause
        uint256 timestamp;
    }

    mapping(uint256 => IdentityRecord) public records;

    event IdentityLogged(uint256 indexed id, string nickname, string milestone);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs personal milestone record
    function logIdentity(string calldata nickname, string calldata milestone, string calldata safeguard) external onlyOverseer {
        recordCount++;
        records[recordCount] = IdentityRecord({
            id: recordCount,
            nickname: nickname,
            milestone: milestone,
            safeguard: safeguard,
            timestamp: block.timestamp
        });
        emit IdentityLogged(recordCount, nickname, milestone);
    }

    /// @notice Citizens can view personal milestone records
    function viewIdentity(uint256 id) external view returns (IdentityRecord memory) {
        return records[id];
    }
}
