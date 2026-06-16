// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HeritageCodex
/// @notice Codex covenant to encode Vinvin's cultural and historical governance record
contract HeritageCodex {
    address public overseer;
    uint256 public heritageCount;

    struct HeritageRecord {
        uint256 id;
        string nickname;   // Unknown, No Name, Unlocked Character
        string contribution; // industry, university, leadership, cultural milestone
        string source;     // institution, project, community
        string safeguard;  // authorship clause, equity clause
        uint256 timestamp;
    }

    mapping(uint256 => HeritageRecord) public records;

    event HeritageLogged(uint256 indexed id, string nickname, string contribution);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs heritage record
    function logHeritage(string calldata nickname, string calldata contribution, string calldata source, string calldata safeguard) external onlyOverseer {
        heritageCount++;
        records[heritageCount] = HeritageRecord({
            id: heritageCount,
            nickname: nickname,
            contribution: contribution,
            source: source,
            safeguard: safeguard,
            timestamp: block.timestamp
        });
        emit HeritageLogged(heritageCount, nickname, contribution);
    }

    /// @notice Citizens can view heritage records
    function viewHeritage(uint256 id) external view returns (HeritageRecord memory) {
        return records[id];
    }
}
